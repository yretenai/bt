// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Forge Scimitar File
#pragma magic [ 73 63 69 6D 69 74 61 72 00 ] @ 0x00

#include "NeptuwuniumInt.hexpat"

struct ScimitarHeader {
	str magic;
	uint32_t version;
	uint64_t fat_offset;
	uint64_t id;
	uint32_t flags;
	uint32_t unknown;
};

struct ScimitarFATFile {
	int64_t offset;
	uint64 id;
	int32_t size;
};

struct ScimitarFATStatus {
	uint32_t data;
	uint64_t id;
	uint32_t attributes;
};

struct ScimitarFATAttribute {
	int32_t compressed_size;
	uint64_t hash;
	uint32_t version;
	uint32_t type_id;
	uint64_t attributes;
	int32_t next;
	int32_t previous;
	int32_t parent;
	int32_t timestamp;
	char name[0x80];
	ScimitarFATStatus status;
	int32_t flags;
};

struct ScimitarFATSpan;

struct ScimitarFATSpan {
	int32_t file_count;
	int32_t directory_count;
	int64_t file_offset;
	int64_t end_offset;
	int32_t first_index;
	int32_t last_index;
	int64_t attribute_offset;
	int64_t directory_offset;

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
	int32_t file_count;
	int32_t directory_count;
	int64_t max_id;
	int32_t root_id;
	int32_t first_free_file;
	int32_t first_free_dir;
	int32_t size_of_span;
	int32_t span_count;
	int64_t span_offset;

	ScimitarFATSpan spans[span_count] @ span_offset;
};

ScimitarHeader header @ 0;
ScimitarFAT fat @ header.fat_offset;
