// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine NuTexture
#pragma magic [ 4E 54 50 33 ] @ 0x00 // NTP3; PS3
#pragma endian big

import std.core;
import std.mem;

#include "Flight.hexpat"

enum NUTFormat : u8 {
	BC1 = 0x0,
	BC2 = 0x1,
	BC3 = 0x2,
	B5G5R5A1= 0x6,
	B4G4R4A4 = 0x7, 
	B5G6R5 = 0x8,
	A8R8G8B8 = 0xe,
	B8G8R8A8 = 0x11,
	BC4 = 0x15,
	BC5 = 0x16,
};

struct NUTGlobalIndex {
	u32 index;
	u32 reserved [[hidden]];
};

struct NUTSurfaceExtraData {
	u32 start = $;
	u32 magic;
	u32 size;
	u32 end = start + size;

	if (magic == 0x47494458) {
		NUTGlobalIndex gidx;
	}

	if ($ < end) {
		u8 extra[end - $] [[hidden]];
	}
};

struct NUTSurfaceExtra {
	u32 start = $;
	u32 magic;
	u32 size;
	u32 header_size;
	u32 reserved;
	u32 end = start + size;

	NUTSurfaceExtraData extra[while($ < end)];

	if ($ < end) {
		u8 extra[end - $] [[hidden]];
	}
};

struct NUTSurface {
	u32 start = $;
	u32 size;
	u32 palette_size;
	u32 pixel_size;
	u16 header_size;
	u16 palette_count;
	u8 surface_type;
	u8 mipmap_count;
	NUTFormat palette_type;
	NUTFormat image_type;
	u16 width;
	u16 height;
	// ImHex doesn't bit reverse bitfields, nor does enum flags
	u32 caps1; // DDSCAPS1
	u32 caps2; // DDSCAPS2
	u32 pixel_offset;
	u32 reserved1 [[hidden]];
	u32 reserved2 [[hidden]];
	u32 reserved3 [[hidden]];

	if ((caps2 & 0xFE00) != 0) {
		u32 largest_mip_x;
		u32 largest_mip_y;
		std::mem::AlignTo<16>;
	}

	u32 extr [[hidden, no_unique_address]];
	if (mipmap_count > 0 && extr != 0x745865) {
		u32 mip_sizes[mipmap_count];
		std::mem::AlignTo<16>;
	}

	if (header_size - 0x30 > 0x10) {
		NUTSurfaceExtra extra;
	}

	u32 end = start + size;

	if ($ < end) {
		u8 extra[end - $] [[hidden]];
	}

	// version 1: <header> <data> <header> <data>
	// version 2: <header> <header> <data> <data>
	if (parent.version == 1) {
		u8 pixel_data[pixel_size];
	}
};

struct NUT {
	u32 magic;
	u8 version;
	u8 platform;
	u16 surface_count;
	u32 reserved1 [[hidden]];
	u32 reserved2 [[hidden]];

	NUTSurface surfaces[surface_count];
};

NUT nu @ 0;
