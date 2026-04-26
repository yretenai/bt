// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description RAD Granny2 Model
#pragma magic [ B5 95 11 0E 4B B5 A5 6A 50 28 28 EB 04 B3 78 25 ] @ 0
#pragma magic [ E3 D4 95 31 62 4F DC 20 3A D0 36 CC 89 FF 82 B1 ] @ 0

#include "NeptuwuniumInt.hexpat"
import type.guid;

enum Granny2Compression : uint32_t {
	None,
	OodleLZH,
	OodleLZF,
	BitKnitLZH,
	BitKnitLZF,
};
ss
enum Granny2SectorId : uint32_t {
	Main,
	RigidVertex,
	RigidIndex,
	DeformableVertex,
	DeformableIndex,
	Texture,
	Discard,
	Unloaded
};

struct Granny2Header {
	type::GUID magic;
	uint32_t header_size;
	uint32_t version;
	uint32_t reserved[2] [[hidden]];
};

struct Granny2Ref {
	uint32_t from;
	uint32_t offset;
};

struct Granny2FileInfo {
	uint32_t version;
	uint32_t file_size;
	uint32_t checksum;
	uint32_t sector_offset;
	uint32_t sector_count;
	Granny2Ref type_ref;
	Granny2Ref root_ref;
	uint32_t tag;
	uint32_t extra_tags[4];
	uint32_t string_checksum;
	uint32_t reserved[3] [[hidden]];
};

struct Granny2Sector {
	Granny2Compression compress_type;
	uint32_t offset;
	uint32_t compressed_size;
	uint32_t size;
	uint32_t alignment;
	uint32_t meta1;
	uint32_t meta2;
	uint32_t fixup_offset;
	uint32_t fixup_count;
	uint32_t marshal_fixup_offset;
	uint32_t marshal_fixup_count;
};

struct Granny2Fixup {
	uint32_t from;
	Granny2Ref target;
};

struct Granny2MarshalFixup {
	uint32_t count;
	Granny2Fixup fixup;
};

struct Granny2File {
	Granny2Header header;
	Granny2FileInfo file_info;
	Granny2Sector sectors[file_info.sector_count];
};

Granny2File header @ 0;
