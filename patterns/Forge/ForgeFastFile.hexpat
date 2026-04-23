// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Forge Fast File
#pragma magic [ ?? AA FB 57 99 FA 04 01 ] @ 0x00

#include "NeptuwuniumInt.hexpat"

struct ForgeContainerBlockInfo {
	int32_t size;
	int32_t compressed_size;
};

enum ForgeCompressionType : uint8_t {
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
	uint8_t tag_version;
	uint24_t magic;
	uint32_t container_type;
	uint16_t version;
	ForgeCompressionType compression_type;
	uint32_t block_size;
	int32_t block_count;

	if ((block_size & 0x80000000) != 0) {
		ForgeContainerBlockInfo blocks[block_count];
	}
};

ForgeContainerHeader stream @ 0;
