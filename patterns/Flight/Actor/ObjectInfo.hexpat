// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description ACI Object Info
#pragma endian big

struct Record {
	u16 mnt_id;
	u16 group_id_mask;
	u16 flag_mask;
	u8 reserved[0xa];
};

struct ObjectInfo {
	u16 count;
	u16 group_id;
	u16 flags;
	u8 reserved[0xa];

	Record entries[count];
};

ObjectInfo info @ 0;
