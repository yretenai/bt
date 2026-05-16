// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Dead or Alive 6 BIN file
#pragma array_limit 0xffffffff

#include "KTGL.hexpat"

struct BINHeader {
	u32 version;
	u32 id_offset;
	u32 count;
	u32 alignment [[hidden]];
	u32 table_offset;
	u32 data_start;
};

struct BlockTableHeader {
	u32 count;
	u32 lookup_offset;
	u32 lookup_count;
} [[fixed_size(16)]];

struct BlockEntry {
	KTID name_hash;
	u32 index;
};

struct BlockInfo {
	u64 offset;
	u32 memory_size;
	u32 compressed_size; // Zlib Data
	u32 encrypted_size; // AES-256-CBC encrypted data with PKCS7 padding
	u8 hash[16]; // doubles as encryption key, see Annex 1 at the bottom
};

struct BlockPtr {
	u32 offset;

	BlockInfo info @ parent.pos + offset;

	// order of priority: encrypted_size > compressed_size > memory_size
	if (info.encrypted_size > 0) {
		// compressed if compressed_size is non-zero, otherwise just plain data.
		u8 encrypted_data[info.encrypted_size] @ parent.data_start + info.offset;
	} else if (info.compressed_size > 0) {
		// Zlib compressed data
		u8 compressed_data[info.compressed_size] @ parent.data_start + info.offset;
	} else if (info.memory_size > 0) {
		// Plain data
		u8 data[info.memory_size] @ parent.data_start + info.offset;
	}
};

struct BlockTable {
	auto pos = $;
	auto data_start = parent.header.data_start + pos;

	BlockTableHeader header;
	BlockPtr blocks[header.count];
	BlockEntry lookup[header.lookup_count] @ pos + header.lookup_offset;
};

struct BINFile {
	BINHeader header;
	KTID block_types[header.count] @ header.id_offset;

	// only valid block_type is 0x0A9BFFB9, but it's some type id lookup.
	if (block_types[0] == 0x0A9BFFB9) {
		BlockTable block_table @ header.table_offset;
	}
};

BINFile bin @ 0;

/*
Annex 1 - Decryption:
	Game uses AES-256-CBC, with PKCS7 padding.

	The IV is the hash, sorted by if the first bit is set or not.
	Basically if the byte is ODD, it gets pushed to the front.

		i.e.
			00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f
		becomes
			01 03 05 07 09 0b 0d 0f 00 02 04 06 08 0a 0c 0e

	The Key is the hash turned into a lowercase hex string.
	Then sorted by if it's a digit or not.

		i.e.
			00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f
		becomes
			"000102030405060708090a0b0c0d0e0f"
		which sorts to
			"00010203040506070809000000abcdef"
*/
