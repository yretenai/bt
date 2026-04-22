// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description World of Warships Moo Terrain Heightmap
#pragma magic [ 74 72 62 00 ] @ 0

#include "NeptuwuniumInt.hexpat"

struct TerrainHeader {
	uint32_t magic;
	uint32_t width;
	uint32_t height;
	uint16_t table_size;
	uint16_t format;
	float min;
	float max;
	float table[(table_size * table_size) << 1];
};

struct TerrainSlice {
	float start;
	float curve;
	float prev = start;
	float next = curve;
	int additional = 0;
	while(prev != next) {
		float curve;
		prev = next;
		next = curve;
		additional += 1;
	}
	int32_t repeat;
	int32_t total = repeat + additional;
};

struct TerrainFile {
	TerrainHeader header;
	int32_t total = header.width * header.height;
	int32_t remain = header.width * header.height;
	while (remain > 0) {
		TerrainSlice slice;
		remain -= slice.total;
	}
};

TerrainFile file @ 0;
