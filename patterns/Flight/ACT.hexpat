// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine ACT Text List
#pragma magic [ 41 43 54 00 ] @ 0x00

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
	char lang[2];
	uint16_t index;
};

struct ACTText {
	uint32_t text_offset_table;
	char16 data[] @ text_offset_table;
};

struct ACTTextInfo {
	uint32_t label_offset;
	ACTText text[parent.parent.language_count];

	char label[] @ label_offset;
};

struct ACTTextOffset {
	uint32_t offset;
	ACTTextInfo info @ offset;
};

struct ACTHash {
	HashId hash_id;
	uint32_t label_offset;
	uint32_t text_index;

	char label[] @ label_offset;
};

struct ACT {
	uint32_t magic;
	uint32_t version;
	uint32_t data_version;
	bool is_big_endian;
	uint8_t language_count;
	uint16_t reserved1 [[hidden]];
	uint32_t text_count;
	uint32_t hash_count;
	uint32_t language_table_offset;
	uint32_t text_table_offset;
	uint32_t hash_table_offset;

	ACTLanguage languages[language_count] @ language_table_offset;
	ACTTextOffset texts[text_count] @ text_table_offset;
	ACTHash hashes[hash_count] @ hash_table_offset;
};

ACT act @ 0;
