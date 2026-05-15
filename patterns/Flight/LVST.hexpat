// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine LVST Value Table
#pragma magic [ 4C 56 53 54 ] @ 0x00
#pragma endian big

#include "Flight.hexpat"

enum LVSTColumnType : uint8_t {
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
	uint8_t element_size;
	uint8_t element_count;
	uint8_t reserved;
	uint32_t count;

	if (type == LVSTColumnType::Byte || type == LVSTColumnType::Buffer) {
		LVSTCell<uint8_t> rows[count];
	} else if (type == LVSTColumnType::Float) {
		LVSTCell<float> rows[count];
	} else if (type == LVSTColumnType::Int || type == LVSTColumnType::Date || type == LVSTColumnType::Time) {
		LVSTCell<uint32_t> rows[count];
	} else if (type == LVSTColumnType::Hash) {
		LVSTCell<HashId> rows[count];
	}
};

struct LVSTColumnInfo {
	uint32_t offset;

	LVSTColumn data @ offset;
};

struct LVST {
	uint32_t magic;
	uint32_t version;
	uint32_t reserved1 [[hidden]];
	uint32_t reserved2 [[hidden]];
	uint32_t column_id_size;
	HashId column_ids[column_id_size / 4];
	uint32_t column_info_size;
	LVSTColumnInfo column_info[column_info_size / 4];
	uint32_t column_cell_size;
};

LVST lvst @ 0;
