// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description ACI !!Custom!! MAGE Actor 
#pragma magic [ 4D 41 47 45 ] @ 0x00

#include "Neptuwunium.hexpat"

struct MAGEPointer {
	u32 offset;
	u32 size;

	u8 data[size] @ offset;
};

struct MAGE {
	u32 magic;
	u8 version[3];
	bool data_is_big_endian;
	s32 table_offset;
	s32 count;
	s32 alignment;
	s32 type;
	u32 game;
	PString32 name;

	MAGEPointer entries[count] @ table_offset;
};

MAGE mage @ 0;
