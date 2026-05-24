// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine Actor Name
#pragma endian big

#include "Flight.hexpat"

struct ACEActorName {
	u32 length;
	u32 min;
	u32 max;
	u32 unknown;
	CFixString8<0x3f0> name;
};

ACEActorName name @ 0;
