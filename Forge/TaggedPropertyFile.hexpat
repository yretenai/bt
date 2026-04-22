// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Forge Tagged Property File

#include "Forge/Forge.hexpat"
#include "NeptuwuniumInt.hexpat"

struct BlockAllocatorInfo<Type> {
	Type type_id;
	uint32_t size;
};

struct BlockAllocator {
	uint16_t version;

	if (version == 0) {
		uint16_t count;
		BlockAllocatorInfo<uint32_t> allocator_info[count]; 
	} else {
		if (version > 2) {
			bool has_partial_info;
		} else {
			bool has_partial_info = false;
		}

		uint16_t count;
		BlockAllocatorInfo<uint16_t> allocator_info[count];

		if (has_partial_info) {
			uint16_t partial_count;
			BlockAllocatorInfo<uint64_t> partial_allocator_info[partial_count];
		}
	}
};

struct FastFileHeader {
	uint32_t tag;
	int32_t size;
	ForgeString name;

	bool has_block_info;
	if (has_block_info) {
		BlockAllocator allocator;
	}
};

FastFileHeader file @ 0;
