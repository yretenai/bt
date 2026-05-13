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

enum FHMItemType : uint32_t {
	Normal,
	Child
};

struct FHMItemData {
	uint16_t memory_index;
	FHMMemoryType memory_type;
	uint32_t alignment;
	uint32_t offset;
	uint32_t size;

	uint8_t data[size] @ offset;
};

using FHM;

struct FHMItem {
	FHMItemType item_type;
	uint32_t offset;
	if (item_type == FHMItemType::Normal) {
		FHMItemData data @ parent.pos + offset;
	} else {
		FHM child @ parent.pos + offset;
	}
};

struct FHM {
	uint32_t pos = $; 
	uint32_t count;
	FHMItem items[count];
};

FHM fhm @ 0;
