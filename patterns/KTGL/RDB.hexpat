// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description KTGL Resource Database File
#pragma magic [ 5F 44 52 4B 30 30 30 30 ] @ 0x00

#pragma array_limit 0xffffffff
#pragma pattern_limit 0xffffffff

#include "KTGL.hexpat"

struct RDBData {
	KTGLHeader header;
	KTGLPlatform platform;
	uint32_t count;
	KTID ndb_id;
	char external_path[];
};

bitfield RDBRDXLinkFlags {
	unknown0 : 1;
	unknown1 : 1;
	rdx_ref : 1;
	loose : 1;
	unknown4 : 1;
	unknown5 : 1;
	unknown6 : 1;
	unknown7 : 1;
} [[fixed_size(1)]];

struct RDBRDXLink<TSize> {
	uint8_t sentinel;
	RDBRDXLinkFlags flags;
	TSize offset;
	TSize disk_size;
	uint16_t rdx_id;
	uint8_t unknown;
};

struct RDBIndexData {
	RDBIndex inner [[inline]];

	uint8_t sentinel [[no_unique_address]];

	if(sentinel != 1) {
		char path_info[memory_size];
	} else {
		int32_t link_sz = inner.disk_size - 0x7;
		if (link_sz == 0) {
			RDBRDXLink<uint8_t> rdx_link;
		} else if (link_sz == 2) {
			RDBRDXLink<uint16_t> rdx_link;
		} else if (link_sz == 4) {
			RDBRDXLink<uint24_t> rdx_link;
		} else if (link_sz == 6) {
			RDBRDXLink<uint32_t> rdx_link;
		} else if (link_sz == 8) {
			RDBRDXLink<uint40_t> rdx_link;
		} else if (link_sz == 10) {
			RDBRDXLink<uint48_t> rdx_link;
		} else if (link_sz == 12) {
			RDBRDXLink<uint58_t> rdx_link;
		} else if (link_sz == 14) {
			RDBRDXLink<uint64_t> rdx_link;
		}
	}

	std::mem::AlignTo<4>;
};

RDBData root @ 0;
RDBIndexData index[root.count] @ root.header.size;
