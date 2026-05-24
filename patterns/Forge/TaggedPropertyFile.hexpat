// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Forge Tagged Property File

#include "Forge.hexpat"

struct BlockAllocatorInfo<Type> {
	Type type_id;
	u32 size;
};

struct BlockAllocator {
	u16 version;

	if (version == 0) {
		u16 count;
		BlockAllocatorInfo<u32> allocator_info[count];
	} else {
		if (version > 2) {
			bool has_partial_info;
		} else {
			bool has_partial_info = false;
		}

		u16 count;
		BlockAllocatorInfo<u16> allocator_info[count];

		if (has_partial_info) {
			u16 partial_count;
			BlockAllocatorInfo<u64> partial_allocator_info[partial_count];
		}
	}
};

struct FastFileHeader {
	u32 tag;
	s32 size;
	ForgeString name;

	bool has_block_info;
	if (has_block_info) {
		BlockAllocator allocator;
	}
};

FastFileHeader file @ 0;
