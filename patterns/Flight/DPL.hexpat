// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine DPL Table
#pragma endian big

#include "NeptuwuniumInt.hexpat"

enum DPLCompressType : uint8_t {
	LZ77,
	DEFLATE,
	NONE,
};

enum FHMMemoryType : int32_t {
	CPU, // asset data
	GPU, // graphics data
	VIRT, // zero'd memory
	COUNT
};

struct ACEHeader {
	uint8_t magic[3]; // "D", "P", "L" or "F", "H", "M"
	bool is_big_endian;
	uint32_t version; // 20101010 = 2010-10-10
	uint32_t date; // yyyymmddxx
};

struct DPLHeader {
	ACEHeader ace;
	uint32_t count;
	uint32_t size; // size of the header blob
};

struct FHMMemoryRange {
	FHMMemoryType memory_type;
	uint32_t size;
	uint32_t align;
};

struct FHMHeader {
	ACEHeader ace;
	uint32_t mem_range_count;
	uint32_t fhm_size;
	uint32_t full_memory_size;
	uint32_t memory_sizes[FHMMemoryType::COUNT];
	uint32_t alignment[FHMMemoryType::COUNT];
	uint64_t offset; // read blocks at 0x20000 bytes at a time, aligned to 16 bytes
	uint32_t disk_size;
	uint32_t group_id; // assets with the same id are loaded together
	uint32_t resource_id; // crc32($"DPL::[0x{crc32(name):x08}]") OR just crc32(name), crc32/ethernet flavor
	uint16_t seed; // if not zero, calculate pi and xor the buffer with it. see xor_table.py
	bool is_deleted;
	uint8_t rsvd [[hidden]]; // unallocated stack memory.
	FHMMemoryRange mem_ranges[mem_range_count];
};

struct CompressHeader {
	uint8_t magic; // "C"
	DPLCompressType compression_type;
	uint16_t index;
	uint32_t checksum; // crc32(data), crc32/ethernet flavor
	uint32_t memory_size;
	uint32_t disk_size;
	uint8_t data[disk_size];
	// what follows is more CompressHeader buffers
	// final buffer has random junk bytes after the compressed data to "obfuscate".
};

struct DPL {
	DPLHeader dpl;
	FHMHeader fhm[dpl.count];
	CompressHeader hdr @ fhm[0].offset;
};

DPL dpl @ 0;
