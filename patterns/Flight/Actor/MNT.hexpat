// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description ACI MNT Model Node Tree
#pragma magic [ 4D 4E 54 00 ] @ 0x00
#pragma endian big

#include "Flight.hexpat"

struct MNTNode {
	u16 index;
	u16 child_count;
	u16 child_index;
	u16 parent_index;
	HashId hash; // hash of mesh object name or hash of mop bone name
	u16 name_offset; // this is bugged. It's related to the previous resolved offset - current header offset.
	u16 group_id;
	u32 flags;

	u16 child_ids[child_count] @ parent.child_offset + child_index * 2;
};

struct MNT {
	u32 magic;
	u16 version[2];
	u32 size;
	u16 count;
	u16 reserved [[hidden]];
	u32 flags;
	HashId hash;
	u32 hash_offset;
	u32 id_offset;
	u32 parent_offset;
	u32 node_offset;
	u32 child_offset;
	u32 name_offset;

	CString8 names[count] @ name_offset;
	HashId hashes[count] @ hash_offset; // hash of mesh object name or hash of mop bone
	u16 node_ids[count] @ id_offset;
	u16 parent_ids[count] @ parent_offset;
	MNTNode nodes[count] @ node_offset;
};

MNT mnt @ 0;
