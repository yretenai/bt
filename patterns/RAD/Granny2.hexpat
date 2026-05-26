// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description RAD Granny2
#pragma magic [ B5 95 11 0E 4B B5 A5 6A 50 28 28 EB 04 B3 78 25 ] @ 0
#pragma magic [ E3 D4 95 31 62 4F DC 20 3A D0 36 CC 89 FF 82 B1 ] @ 0

import type.guid;

#include "Neptuwunium.hexpat"

enum Granny2Compression : u32 {
	None,
	OodleLZH,
	OodleLZF,
	BitKnitLZH,
	BitKnitLZF,
};
ss
enum Granny2SectorId : u32 {
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
	u32 header_size;
	u32 version;
	u32 reserved[2] [[hidden]];
};

struct Granny2Ref {
	u32 section;
	u32 offset;
};

struct Granny2FileInfo {
	u32 version;
	u32 file_size;
	u32 checksum;
	u32 sector_offset;
	u32 sector_count;
	Granny2Ref type_ref;
	Granny2Ref root_ref;
	u32 tag;
	u32 extra_tags[4];
	u32 string_checksum;
	u32 reserved[3] [[hidden]];
};

struct Granny2Sector {
	Granny2Compression compress_type;
	u32 offset;
	u32 compressed_size;
	u32 size;
	u32 alignment;
	u32 meta1;
	u32 meta2;
	u32 fixup_offset;
	u32 fixup_count;
	u32 marshal_fixup_offset;
	u32 marshal_fixup_count;
};

struct Granny2Fixup {
	u32 offset;
	Granny2Ref target;
};

struct Granny2MarshalFixup {
	u32 count;
	Granny2Fixup fixup;
};

struct Granny2File {
	Granny2Header header;
	Granny2FileInfo file_info;
	Granny2Sector sectors[file_info.sector_count];
};

Granny2File header @ 0;
