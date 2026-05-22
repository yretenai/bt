// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine Store Table File
#pragma magic [ 99 83 FD 77 ] @ 0x00
#pragma endian little

#include "Flight.hexpat"

struct ID {
	u16 item_id
	char id1[0x10];
	char id2[0x10];
	if (parent.version == 2013071301) {
		char sig[0x6];
	}
	HashId name;
	u32 reserved;
};

struct IDTBL {
	u32 magic;
	u32 version;
	u16 count;
	ID entries[count];
};

IDTBL table @ 0;
