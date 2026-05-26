// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description ACI FHM Asset
#pragma endian big

#include "Neptuwunium.hexpat"

enum FHMItemType : u32 {
	Normal,
	Child
};

struct FHMItemData {
	u16 memory_index;
	FHMMemoryType memory_type;
	u32 alignment;
	u32 offset;
	u32 size;

	u8 data[size] @ offset;
};

using FHM;

struct FHMItem {
	FHMItemType item_type;
	u32 offset;
	if (item_type == FHMItemType::Normal) {
		FHMItemData data @ parent.pos + offset;
	} else {
		FHM child @ parent.pos + offset;
	}
};

struct FHM {
	u32 pos = $;
	u32 count;
	FHMItem items[count];
};

FHM fhm @ 0;
