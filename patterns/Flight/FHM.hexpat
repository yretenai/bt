// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine FHM Table
#pragma endian big

#include "NeptuwuniumInt.hexpat"


enum FHMMemoryType : uint16_t {
	CPU, // asset data
	GPU, // graphics data
	VIRT, // zero'd memory
	COUNT
};

struct FHMItemData {
	uint16_t memory_index;
	FHMMemoryType memory_type;
	uint32_t alignment;
	uint32_t offset;
	uint32_t size;

	uint8_t data[size] @ offset;
};

struct FHMItem {
	uint64_t pointer;
	FHMItemData data @ pointer;
};

struct FHM {
	uint32_t count;
	FHMItem items[count];
};

FHM fhm @ 0;
