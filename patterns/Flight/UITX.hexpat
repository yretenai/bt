// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine 2D UI Texture
#pragma magic [ 55 49 54 58 ] @ 0x00
#pragma endian big

#include "Flight.hexpat"

struct UITXVariableTexture {
	uint32_t nut_header_fhm_index;
	uint32_t nut_fhm_index;
	uint32_t texture_index;
};

struct UITXTexture {
	Vector4<uint16_t> xywh;
	uint32_t index;
};

struct UITX {
	uint32_t magic;
	uint32_t variable_count;
	uint32_t variable_offset;
	uint32_t texture_count;
	uint32_t texture_offset;

	UITXVariableTexture variable[variable_count] @ variable_offset;
	UITXTexture textures[texture_count] @ texture_offset;
};

UITX ui @ 0;
