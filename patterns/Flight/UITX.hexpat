// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description ACI UITX Texture
#pragma magic [ 55 49 54 58 ] @ 0x00
#pragma endian big

#include "Flight.hexpat"

struct UITXVariableTexture {
	u32 nut_header_index;
	u32 nut_index;
	u32 surface_index;
};

struct UITXTexture {
	Vector4<u16> xywh;
	u32 index;
};

struct UITX {
	u32 magic;
	u32 variable_count;
	u32 variable_offset;
	u32 texture_count;
	u32 texture_offset;

	UITXVariableTexture variable[variable_count] @ variable_offset;
	UITXTexture textures[texture_count] @ texture_offset;
};

UITX ui @ 0;
