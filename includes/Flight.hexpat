// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#include "Neptuwunium.hexpat"

using HashId = u32 [[format_read("format_hashid")]];

fn format_hashid(ref HashId id) {
	return std::format("[0x{:08x}]", id);
};

struct ACEHeader {
	u8 magic[3]; // "D", "P", "L" or "F", "H", "M"
	bool is_big_endian;
	u32 version; // 20101010 = 2010-10-10
	u32 date; // yyyymmddxx
};

enum FHMMemoryType : u16 {
	CPU,
	GPU,
	SHARED,
	COUNT,
};

