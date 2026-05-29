// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description HEAT Mesh
#pragma array_limit 0x1fffffff

import std.sys;

#include "HEAT.hexpat"

struct Submesh {
	PString32 name;

	u32 unknown; // probably flags
	u32 first_index;
	u32 vertex_count;
	u32 face_count;

	std::assert(unknown == 0, "unknown is not 0");
};

struct UVBuffer {
	u8 uv_type;

	if(uv_type == 1) {
		half vertex_uv_buffer[parent.vertex_count * 2];
	} else if(uv_type == 0) {
		float vertex_uv_buffer[parent.vertex_count * 2];
	} else {
		std::assert(false, "uv_type is not 0 or 1");
	}
};

// the lack of alignment in this file is making me very upset
// engine would be perfect otherwise lol
struct Mesh {
	u32 version;
	Vector3F min;
	Vector3F max;
	Vector3F scale;
	float bias;
	u32 unknown;
	std::assert(unknown == 0, "unknown is not 0");

	u32 submesh_count;
	Submesh submeshes[submesh_count];

	u32 vertex_count;

	u8 vertex_buffer_type;
	if(vertex_buffer_type == 0) {
		Vector3F vertex_position_buffer[vertex_count];
		u32 vertex_normal_buffer[vertex_count]; // R10G10B10A2 probably, values never go over 0x3fffffff
		u32 vertex_tangent_buffer[vertex_count]; // R10G10B10A2 probably
	} else if(vertex_buffer_type == 1) {
		Vector4H vertex_position_buffer[vertex_count]; // ? x, y, z, zero. scaled to min/max maybe?
		u32 vertex_normal_buffer[vertex_count]; // R10G10B10A2 probably, values never go over 0x3fffffff
		u32 vertex_tangent_buffer[vertex_count]; // R10G10B10A2 probably
	} else {
		std::assert(false, "vertex_buffer_type is not 0 or 1");
	}

	u8 num_uvs; // num uvs?
	u8 unknown3_1;
	u8 unknown3_2;
	u8 unknown3_3;
	std::assert(unknown3_1 == 0, "unknown3_1 is not 0");
	std::assert(unknown3_2 == 0, "unknown3_2 is not 0");
	std::assert(unknown3_3 == 0, "unknown3_3 is not 0");
	UVBuffer uvs[num_uvs];

	u8 unknown4; // 0 <-- pretty sure this is buffer type
	std::assert(unknown4 == 0, "unknown4 is not 0");
	u32 index_buffer_size;
	if (vertex_count > 0xffff) {
		u32 index_buffer[index_buffer_size];
	} else {
		u16 index_buffer[index_buffer_size * 2];
	}

	u8 skin_type;
	if (skin_type == 1) {
		u32 weight_count;
		u32 weight_buffer[weight_count];
		u32 index_buffer[vertex_count];
	} else if(skin_type == 2) {
		u16 skin_buffer[vertex_count]; // 1 bone per vertex?
	} else {
		std::assert(false, "skin_type is not 1 or 2");
	}

	u32 skeleton_type; // 4 <-- pretty sure this is buffer type
	std::assert(skeleton_type == 4, "skeleton_type is not 4");
	Skeleton skeleton;
};

Mesh mesh @ 0;
