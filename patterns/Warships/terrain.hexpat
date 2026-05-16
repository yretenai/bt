// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description World of Warships Moo Terrain Heightmap
#pragma magic [ 74 72 62 00 ] @ 0

#include "NeptuwuniumInt.hexpat"

struct TerrainHeader {
	u32 magic;
	u32 width;
	u32 height;
	u16 table_size;
	u16 format;
	float min;
	float max;
	float table[(table_size * table_size) << 1];
};

struct TerrainSlice {
	float start;
	float curve;
	float prev = start;
	float next = curve;
	s32 additional = 0;
	while(prev != next) {
		float curve;
		prev = next;
		next = curve;
		additional += 1;
	}
	s32 repeat;
	s32 total = repeat + additional;
};

struct TerrainFile {
	TerrainHeader header;
	s32 total = header.width * header.height;
	s32 remain = header.width * header.height;
	while (remain > 0) {
		TerrainSlice slice;
		remain -= slice.total;
	}
};

TerrainFile file @ 0;
