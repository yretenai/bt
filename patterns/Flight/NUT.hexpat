// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine NuTexture
#pragma magic [ 4E 54 50 33 ] @ 0x00
#pragma magic [ 4E 54 57 44 ] @ 0x00

import std.core;

std::core::set_endian(std::mem::Endian::Big);
u32 magic @ 0 [[hidden]];
if (magic == 0x4E545744) {
	std::core::set_endian(std::mem::Endian::Little);
}

#include "Flight.hexpat"
#include "NeptuwuniumMath.hexpat"

enum NUTFormat : uint8_t {
	BC1 = 0x0,
	BC2 = 0x1,
	BC3 = 0x2,
	DXN = 0x3,
	CTX1 = 0x4,
	A8 = 0x5,
	L8 = 0x6,
	R5G6B5 = 0x7,
	R6G5B5 = 0x8,
	X1R5G5B5 = 0x9,
	A1R5G5B5 = 0xa,
	A4R4G4B4 = 0xb,
	X4R4G4B4 = 0xc,
	Q4W4V4U4 = 0xd,
	A8L8 = 0xe,
	V8U8 = 0xf,
	G8R8 = 0x10,
	L16 = 0x11,
	R16_FLOAT = 0x12,
	A8R8G8B8 = 0x13,
	X8R8G8B8 = 0x14,
	A8B8G8R8 = 0x15,
	X8B8G8R8 = 0x16,
	X8L8V8U8 = 0x17,
	Q8W8V8U8 = 0x18,
	X2R10G10B10 = 0x19,
	A2B10G10R10 = 0x1a,
	A16L16 = 0x1b,
	G16R16 = 0x1c,
	V16U16 = 0x1d,
	R10G11B11 = 0x1e,
	R11G11B10 = 0x1f,
	W10V11U11 = 0x20,
	W11V11U10 = 0x21,
	G16R16_FLOAT = 0x22,
	L32 = 0x23,
	R32_FLOAT = 0x24,
	A16B16G16R16 = 0x25,
	Q16W16V16U16 = 0x26,
	A16B16G16R16_FLOAT = 0x27,
	A32L32 = 0x28,
	G32R32 = 0x29,
	V32U32 = 0x2a,
	G32R32_FLOAT = 0x2b,
	A32B32G32R32 = 0x2c,
	Q32W32V32U32 = 0x2d,
	A32B32G32R32_FLOAT = 0x2e,
};

enum NUTFlags : uint32_t {
	None,
};

enum NUTFlags2 : uint32_t {
	None,
	Cubemap = 0x200,
	CubemapPosX = 0x400,
	CubemapNegX = 0x800,
	CubemapPosY = 0x1000,
	CubemapNegY = 0x2000,
	CubemapPosZ = 0x4000,
	CubemapNegZ = 0x8000,
};

struct NUTGlobalIndex {
	uint32_t index;
	uint32_t reserved [[hidden]];
};

struct NUTSurfaceExtraData {
	uint32_t start = $;
	uint32_t magic;
	uint32_t size;
	uint32_t end = start + size;

	if (magic == 0x47494458) {
		NUTGlobalIndex gidx;
	}

	if ($ < end) {
		uint8_t extra[end - $] [[hidden]];
	}
};

struct NUTSurfaceExtra {
	uint32_t start = $;
	uint32_t magic;
	uint32_t size;
	uint32_t header_size;
	uint32_t reserved;
	uint32_t end = start + size;

	NUTSurfaceExtraData extra[while($ < end)];

	if ($ < end) {
		uint8_t extra[end - $] [[hidden]];
	}
};

struct NUTSurface {
	uint32_t start = $;
	uint32_t size;
	uint32_t unknown_size;
	uint32_t pixel_size;
	uint16_t header_size;
	uint16_t unknown_count;
	uint8_t unknown1;
	uint8_t mipmap_count;
	uint8_t unknown2;
	NUTFormat image_type;
	uint16_t width;
	uint16_t height;
	NUTFlags flags1;
	NUTFlags2 flags2;
	uint32_t pixel_offset;
	uint32_t reserved1 [[hidden]];
	uint32_t reserved2 [[hidden]];
	uint32_t reserved3 [[hidden]];

	if (header_size - 0x30 > 0x10) {
		NUTSurfaceExtra extra;
	}

	// version 1: <header> <data> <header> <data>
	// version 2: <header> <header> <data> <data>
	if (parent.version == 1) {
		uint32_t end = start + size;

		if ($ < end) {
			uint8_t extra[end - $] [[hidden]];
		}

		uint8_t pixel_data[pixel_size];
	}
};

struct NUT {
	uint32_t magic;
	uint8_t version;
	uint8_t unknown1; // dies if zero
	uint16_t surface_count;
	uint32_t reserved1 [[hidden]];
	uint32_t reserved2 [[hidden]];

	NUTSurface surfaces[surface_count];
};

NUT nu @ 0;
