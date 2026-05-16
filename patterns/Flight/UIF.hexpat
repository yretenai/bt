// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine Objectives File
#pragma magic [ 55 49 46 00 ] @ 0x00
#pragma endian big

#include "Flight.hexpat"
#include "NeptuwuniumMath.hexpat"

struct Objective {
	uint32_t id;
	uint32_t msg_id;
	Color32 color;
	uint32_t flag;
};

struct UIF {
	uint32_t magic;
	uint32_t version;
	uint32_t count;
	Objective info[count];
};

UIF uif @ 0;
