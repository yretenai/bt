// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description ACI LVST Table
#pragma magic [ 4C 56 53 54 ] @ 0x00
#pragma endian big

#include "Flight.hexpat"

enum LVSTColumnType : u8 {
	None = 0x00,
	Byte = 0x10,
	Buffer = 0x14,
	Float = 0x30,
	Int = 0x40,
	Hash = 0x41,
	Date = 0x91,
	Time = 0x92,
	Null = 0xff,
};

struct LVSTCell<Type> {
	Type data[parent.element_count];
};

struct LVSTColumn {
	LVSTColumnType type;
	u8 element_size;
	u8 element_count;
	u8 reserved;
	u32 count;

	if (type == LVSTColumnType::Byte || type == LVSTColumnType::Buffer) {
		LVSTCell<u8> rows[count];
	} else if (type == LVSTColumnType::Float) {
		LVSTCell<float> rows[count];
	} else if (type == LVSTColumnType::Int || type == LVSTColumnType::Date || type == LVSTColumnType::Time) {
		LVSTCell<u32> rows[count];
	} else if (type == LVSTColumnType::Hash) {
		LVSTCell<HashId> rows[count];
	}
};

struct LVSTColumnInfo {
	u32 offset;

	LVSTColumn data @ offset;
};

struct LVST {
	u32 magic;
	u32 version;
	u32 reserved1 [[hidden]];
	u32 reserved2 [[hidden]];
	u32 column_id_size;
	HashId column_ids[column_id_size / 4];
	u32 column_info_size;
	LVSTColumnInfo column_info[column_info_size / 4];
	u32 column_cell_size;
};

LVST lvst @ 0;
