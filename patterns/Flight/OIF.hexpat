// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine Object Information File
#pragma magic [ 4F 49 46 00 ] @ 0x00
#pragma endian big

#include "Flight.hexpat"

struct ObjectInfo {
	HashId name_id;
	u32 id;
	u32 category;
	u32 flag;
	u32 hp;
	u32 effect_id;
	u32 effect_param;
	float effect_size;
};

struct OIF {
	u32 magic;
	u32 version;
	u32 count;
	ObjectInfo info[count];
};

OIF oif @ 0;
