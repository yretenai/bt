// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine Ace Combat Font
#pragma magic [ 41 43 46 00 ] @ 0x00
#pragma endian big

import std.core;

bool is_big_endian @ 0xD [[hidden]];
if (is_big_endian) {
	std::core::set_endian(std::mem::Endian::Big);
} else {
	std::core::set_endian(std::mem::Endian::Little);
}

#include "Flight.hexpat"
#include "NeptuwuniumMath.hexpat"

struct ACFontLUT {
	u16 index;
	u16 count;
};

struct ACKerning {
	u8 left_upper_char;
	u8 left_lower_char;
	u8 right_upper_char;
	u8 right_lower_char;
	s16 offset;
};

struct ACGlyph {
	u16 uitex_index;
	Vector4<u16> uvxy;
	u16 adv;
	u8 width;
	u8 height;
	u8 upper_char;
	u8 lower_char;
	u16 kerning_index;
	u16 kerning_count;
	u8 type;
	u8 reserved1[0x3] [[hidden]];
};

struct ACFont {
	CFixString8<0x20> name;
	u16 asc;
	u16 desc;
	u16 width;
	u16 height;
	u16 glyph_count;
	u16 kerning_count;
	u32 kerning_offset;
	u32 glyph_offset;

	ACFontLUT lut[0x100];
	ACGlyph glphs[glyph_count] @ glyph_offset;
	ACKerning kerning[kerning_count] @ kerning_offset;
};

struct ACFontPtr {
	u32 offset;

	ACFont font @ offset;
};

struct ACF {
	u32 magic;
	u32 version;
	u32 data_version;
	bool is_big_endian;
	u8 ui_count;
	u8 ui_fhm_idx;
	u8 font_count;
	ACFontPtr font_offset[font_count];
};

ACF acf @ 0;
