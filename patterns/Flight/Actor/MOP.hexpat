// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description ACI Motion Pack
#pragma magic [ 4D 4F 50 32 ] @ 0x00
#pragma endian big

import std.sys;

#include "Flight.hexpat"

enum KFMChannel : u8 {
	FLOAT32 = 0x0, // size 4
	VEC2F = 0x1, // size 4 (2 elements)
	VEC3F = 0x2, // size 4 (3 elements)
	VEC4F = 0x3, // size 4 (4 elements)
	SCALE32 = 0x4, // size 4 (3 elements)
	TRANSLATION32 = 0x5, // size 4 (3 elements)
	ROTATION_RADIANS = 0x6, // size 4 (4 elements)
	ROTATION32W = 0x7, // size 4 (4 elements)
	ROTATION32X = 0x8, // size 4 (3 elements, order is determined with compress_bit_index)
	ROTATION20 = 0x9, // size 8 (1 element)
	ROTATION15 = 0xa, // size 6 (1 element)
	ROTATION10 = 0xb, // size 4 (1 element)
	ROTATION16 = 0xc, // size 2 (4 elements)
};

/*
ROTATION32X:
	x, y, z = float
	w = sqrt(y * y , 1 - x * x - y * y - z * z)

	index = compress_bit_index + frame_index
	order = (compress_offset[index / 4] >> ((index % 4) * 2)) & 3

ROTATION20:
	assuming value = uint32[2]
	order = value[0] & 3

	x, y, z = todo: math

ROTATION15:
	assuming value = uint8[6]
	order = value[5] & 3

	x, y, z = todo: math

ROTATION10:
	assuming value = uint32
	order = value & 3

	x, y, z = todo: math

all:
	switch (order):
		0:
			[x, y, z, w] = [w, x, y, z]
		1:
			[x, y, z, w] = [x, w, y, z]
		2:
			[x, y, z, w] = [x, y, w, z]
		3:
			[x, y, z, w] = [x, y, z, w]

*/

struct KFMFrameNode {
	u16 frame_count;
	u16 compress_bit_index; // 2 bits at index, multiply by 2 to get bit index. only for ROTATION32X.
	u16 frame_id_index;
	u16 value_index;

	u16 frame_ids[frame_count] @ parent.start + parent.frame_offset + frame_id_index * 2;
};

struct KFMFrame {
	u16 start = $;
	u16 magic; // 0xABCD in LE
	u16 frame_offset;
	u16 element_offset;
	u16 compress_offset; // 2 bit stream

	u32 count = (frame_offset - 8) / 8;
	KFMFrameNode nodes[count];
};

struct KFMFramePtr {
	u32 size;
	u32 offset;
	KFMFrame frame @ offset + parent.start;
};

struct KFMNode {
	HashId hash;
	u16 id;
	u16 mnt_id;
	KFMChannel channel;
	u8 count;
	u16 id2;
	u16 frame_node_offset;
	u16 frame_node_count;
	u16 group_id;
	u16 flags2;
	u8 reserved2[0xc];
};

struct KFM {
	u32 start = $;
	u32 magic;
	u8 version[2];
	u16 flags;
	u32 header_size;
	u32 file_size;
	u16 frame_count;
	u16 const_count;
	u16 motion_count;
	u16 frame_info_count;
	u32 node_offset;
	u32 frame_start_offset;
	u32 frame_info_offset;
	HashId hash;
	u32 name_offset;
	u16 group_id;
	u16 group_flags;
	u32 offset;
	u8 node_size;
	u8 reserved[11];

	KFMNode const_nodes[const_count] @ start + node_offset;
	KFMNode motion_nodes[motion_count] @ start + node_offset + ((node_size * const_count) << 4);
	u16 frame_start[frame_info_count] @ start + frame_start_offset;
	KFMFramePtr frames[frame_info_count] @ start + frame_info_offset; // 1st one is for const, others are for motion
	CString8 name @ start + name_offset;
};

struct MOP {
	u32 start = $;
	u32 magic;
	u16 version[2];
	u32 header_size;
	u32 file_size;
	u32 count;
	u32 size_offset;
	u32 anim_offset;
	u32 name_offset;

	u32 sizes[count] @ size_offset;
	NuPtr<KFM> animations[count] @ anim_offset;
	NuPtr<CString8> names[count] @ name_offset;
};

MOP mop @ 0;
