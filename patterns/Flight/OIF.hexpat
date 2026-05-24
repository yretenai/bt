// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine Objectives File
#pragma magic [ 4F 49 46 00 ] @ 0x00
#pragma endian big

#include "Flight.hexpat"

struct Objective {
	u32 msg_id;
	u32 id;
	u32 category;
	u32 flag;
	Vector4<float> color; // assumption
};

struct OIF {
	u32 magic;
	u32 version;
	u32 count;
	Objective info[count];
};

OIF oif @ 0;
