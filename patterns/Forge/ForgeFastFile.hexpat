// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Forge FastFile
#pragma magic [ ?? AA FB 57 99 FA 04 01 ] @ 0x00

#include "Neptuwunium.hexpat"

struct ForgeContainerBlockInfo {
	s32 size;
	s32 compressed_size;
};

enum ForgeCompressionType : u8 {
	LZOPRO_LZ01X_W03_15,
	LZO1X_999,
	LZO2A,
	LZ4,
	LZ4_HC,
	KRAKEN_SUPERFAST,
	KRAKEN_OPT3,
	MERMAID_SUPERFAST,
	MERMAID_OPT3,
	SELKIE_VERYFAST,
	SELKIE_OPT3,
	NO_COMPRESSION,
	ZLIB
};

struct ForgeContainerHeader {
	u8 tag_version;
	u24 magic;
	u32 container_type;
	u16 version;
	ForgeCompressionType compression_type;
	u32 block_size;
	s32 block_count;

	if ((block_size & 0x80000000) != 0) {
		ForgeContainerBlockInfo blocks[block_count];
	}
};

ForgeContainerHeader stream @ 0;
