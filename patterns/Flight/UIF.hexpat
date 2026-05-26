// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description ACI UIF Objectives
#pragma magic [ 55 49 46 00 ] @ 0x00
#pragma endian big

#include "Flight.hexpat"

struct Objective {
	u32 id;
	HashId msg_id;
	Color32 color;
	u32 flags;
};

struct UIF {
	u32 magic;
	u32 version;
	u32 count;
	Objective info[count];
};

UIF uif @ 0;
