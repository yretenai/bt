// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description ACI DPL Table
#pragma magic [ 44 50 4C 01 ] @ 0x00
#pragma magic [ 44 50 4C 00 ] @ 0x00
#pragma endian big

#include "Flight.hexpat"

import std.core;
import std.mem;

enum DPLCompressType : u8 {
	LZ77,
	DEFLATE,
	NONE,
};

struct DPLHeader {
	ACEHeader ace;
	u32 count;
	u32 size; // size of the header blob
};

struct FHMMemoryRange {
	FHMMemoryType memory_type;
	u32 size;
	u32 align;
};

struct FHMHeader {
	ACEHeader ace;
	u32 mem_range_count;
	u32 fhm_size;
	u32 full_memory_size;
	u32 memory_sizes[FHMMemoryType::COUNT];
	u32 alignment[FHMMemoryType::COUNT];
	u64 offset; // read blocks at 0x20000 bytes at a time, aligned to 16 bytes
	u32 disk_size;
	u32 group_id; // assets with the same id are loaded together
	HashId resource_id; // crc32($"DPL::[0x{crc32(name):x08}]") OR just crc32(name), crc32/ethernet flavor
	u16 seed; // if not zero, calculate pi and xor the buffer with it. see xor_table.py
	bool is_deleted;
	u8 rsvd [[hidden]]; // unallocated stack memory.
	FHMMemoryRange mem_ranges[mem_range_count];
};

struct CompressHeader {
	u8 magic; // "C"
	DPLCompressType compression_type;
	u16 index;
	u32 checksum; // crc32(data), crc32/ethernet flavor
	u32 memory_size;
	u32 disk_size;
	u8 data[disk_size];
	// what follows is more CompressHeader buffers
	// final buffer has random junk bytes after the compressed data to "obfuscate".
};

struct DPL {
	DPLHeader dpl;
	FHMHeader fhm[dpl.count];
	CompressHeader hdr @ fhm[0].offset;
};

DPL dpl @ 0;
