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
	u32 count;
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
	u8 sentinel;
	RDBRDXLinkFlags flags;
	TSize offset;
	TSize disk_size;
	u16 rdx_id;
	u8 unknown;
};

struct RDBIndexData {
	RDBIndex inner [[inline]];

	if (inner.disk_size > 0) {
		u8 sentinel [[no_unique_address, hidden]];

		if(sentinel != 1) {
			char path_info[inner.disk_size];
		} else {
			s32 link_sz = inner.disk_size - 0x5;
			if (link_sz == 2) {
				RDBRDXLink<u8> rdx_link;
			} else if (link_sz == 4) {
				RDBRDXLink<u16> rdx_link;
			} else if (link_sz == 6) {
				RDBRDXLink<u24> rdx_link;
			} else if (link_sz == 8) {
				RDBRDXLink<u32> rdx_link;
			} else if (link_sz == 10) {
				RDBRDXLink<u40> rdx_link;
			} else if (link_sz == 12) {
				RDBRDXLink<u48> rdx_link;
			} else if (link_sz == 14) {
				RDBRDXLink<u58> rdx_link;
			} else if (link_sz == 16) {
				RDBRDXLink<u64> rdx_link;
			}
		}
	}

	std::mem::AlignTo<4>;
};

RDBData root @ 0;
RDBIndexData index[root.count] @ root.header.size;
