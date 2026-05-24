// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine Ace Combat Text
#pragma magic [ 41 43 54 00 ] @ 0x00

import std.core;

bool is_big_endian @ 0xD [[hidden]];
if (is_big_endian) {
	std::core::set_endian(std::mem::Endian::Big);
} else {
	std::core::set_endian(std::mem::Endian::Little);
}

#include "Flight.hexpat"

import std.mem;
import std.core;

struct ACTLanguage {
	CFixString8<0x3> lang;
	u16 index;
};

struct ACTText {
	u32 text_offset_table;
	CString16 data @ text_offset_table;
};

struct ACTTextInfo {
	u32 label_offset;
	ACTText text[parent.parent.language_count];

	CString8 label @ label_offset;
};

struct ACTTextOffset {
	u32 offset;
	ACTTextInfo info @ offset;
};

struct ACTHash {
	HashId hash_id;
	u32 label_offset;
	u32 text_index;

	CString8 label @ label_offset;
};

struct ACT {
	u32 magic;
	u32 version;
	u32 data_version;
	bool is_big_endian;
	u8 language_count;
	u16 reserved1 [[hidden]];
	u32 text_count;
	u32 hash_count;
	u32 language_table_offset;
	u32 text_table_offset;
	u32 hash_table_offset;

	ACTLanguage languages[language_count] @ language_table_offset;
	ACTTextOffset texts[text_count] @ text_table_offset;
	ACTHash hashes[hash_count] @ hash_table_offset;
};

ACT act @ 0;
