// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Forge Scimitar
#pragma magic [ 73 63 69 6D 69 74 61 72 00 ] @ 0x00

#include "Neptuwunium.hexpat"

struct ScimitarHeader {
	str magic;
	u32 version;
	u64 fat_offset;
	u64 id;
	u32 flags;
	u32 unknown;
};

struct ScimitarFATFile {
	s64 offset;
	uint64 id;
	s32 size;
};

struct ScimitarFATStatus {
	u32 data;
	u64 id;
	u32 attributes;
};

struct ScimitarFATAttribute {
	s32 compressed_size;
	u64 hash;
	u32 version;
	u32 type_id;
	u64 attributes;
	s32 next;
	s32 previous;
	s32 parent;
	s32 timestamp;
	CFixString<0x80> name;
	ScimitarFATStatus status;
	s32 flags;
};

struct ScimitarFATSpan;

struct ScimitarFATSpan {
	s32 file_count;
	s32 directory_count;
	s64 file_offset;
	s64 end_offset;
	s32 first_index;
	s32 last_index;
	s64 attribute_offset;
	s64 directory_offset;

	if (file_offset > -1) {
		ScimitarFATFile indices[file_count] @ file_offset;
	}
	if (attribute_offset > -1) {
		ScimitarFATAttribute attributes[file_count] @ attribute_offset;
	}
	if (directory_offset > -1) {
		ScimitarFATSpan subdirectories[directory_count] @ directory_offset;
	}
};

struct ScimitarFAT {
	s32 file_count;
	s32 directory_count;
	s64 max_id;
	s32 root_id;
	s32 first_free_file;
	s32 first_free_dir;
	s32 size_of_span;
	s32 span_count;
	s64 span_offset;

	ScimitarFATSpan spans[span_count] @ span_offset;
};

ScimitarHeader header @ 0;
ScimitarFAT fat @ header.fat_offset;
