// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine IDTBL File
#pragma magic [ 99 83 FD 77 ] @ 0x00
#pragma endian big

#include "Flight.hexpat"

struct ID {
	u16 group;
	char id1[0x10];
	char id2[0x10];
	char sig[0x6];
	u32 hash;
	u32 reserved;
};

struct IDTBL {
	u32 magic;
	u32 version;
	u8 count;
	u8 reserved;
	ID entries[count];
};

IDTBL table @ 0;
