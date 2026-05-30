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
	std::assert(submesh_count <= 0xff, "submesh count is > 255");
	Submesh submeshes[submesh_count];

	u32 vertex_count;

	u8 vertex_buffer_type;
	if(vertex_buffer_type == 0) {
		Vector3F vertex_position_buffer[vertex_count];
	} else if(vertex_buffer_type == 1) {
		Vector4H vertex_position_buffer[vertex_count]; // ? x, y, z, zero. scaled to min/max maybe?
	} else {
		std::assert(false, "vertex_buffer_type is not 0 or 1");
	}

	u32 vertex_tangent_buffer[vertex_count]; // R10G10B10A2 with A2 being the sign for binormal
	u32 vertex_normal_buffer[vertex_count]; // R10G10B10X2

	u32 num_uvs;
	std::assert(num_uvs <= 3, "uv count is > 3");
	UVBuffer uvs[num_uvs];

	u8 color_buffer_type;
	if(color_buffer_type > 0) {
		if(color_buffer_type == 1) {
			u32 color_buffer[vertex_count];
		} else {
			std::assert(false, "color_buffer_type is not 0 or 1");
		}
	}

	u32 index_buffer_size;
	if (vertex_count > 0xffff) {
		u32 index_buffer[index_buffer_size];
	} else {
		u16 index_buffer[index_buffer_size * 2];
	}

	u8 skin_type;
	if (skin_type > 0) {
		if (skin_type == 1) { // "soft" skinning
			u32 weight_count;
			u32 weight_buffer[weight_count];
			u32 skin_buffer[vertex_count]; // bones indirection
		} else if(skin_type == 2) {
			u16 skin_buffer[vertex_count]; // "hard" skinning
		} else {
			std::assert(false, "skin_type is not 0, 1 or 2");
		}

		Skeleton skeleton;
	}
};

Mesh mesh @ 0;
