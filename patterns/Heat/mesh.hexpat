// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description HEAT Mesh

import std.sys;

#include "Neptuwunium.hexpat"

struct Submesh {
	PString32 name;

	u32 unknown; // probably flags
	u32 first_index;
	u32 vertex_count;
	u32 face_count;

	std::assert(unknown == 0, "unknown is not 0");
};

struct Bone {
	u32 unknown1;
	u32 unknown2;
	u32 unknown3;
	u16 parent_index;
	u16 reserved;

	std::assert(unknown1 == unknown3, "unknown1 is not unknown3");
};

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

	u8 unknown2; // 1 <-- pretty sure this is buffer type
	std::assert(unknown2 == 1, "unknown2 is not 1");
	Vector4H vertex_position_buffer[vertex_count]; // ? x, y, z, zero. scaled to min/max maybe?
	u32 vertex_normal_buffer[vertex_count]; // R11G11B10 probably
	u32 vertex_tangent_buffer[vertex_count]; // R11G11B10 probably

	u8 unknown3; // num uvs?
	std::assert(unknown3 == 1, "unknown3 is not 1");
	u32 unknown3_1; // type?
	std::assert(unknown3_1 == 0, "unknown3_1 is not 0");
	float vertex_uv_buffer[vertex_count* 2];

	u8 unknown4; // 0 <-- pretty sure this is buffer type
	std::assert(unknown4 == 0, "unknown4 is not 0");
	u32 index_buffer_size;
	u16 index_buffer[index_buffer_size * 2];

	u8 unknown5; // 2 <-- pretty sure this is buffer type
	std::assert(unknown5== 2, "unknown5 is not 2");
	u16 skin_buffer[vertex_count]; // 1 bone per vertex?

	u32 unknown6; // 4 <-- pretty sure this is buffer type
	std::assert(unknown6 == 4, "unknown6 is not 4");
	u16 bone_count;
	u32 offset_to_matrices; // ?
	Bone bones[bone_count];
	u32 bone_unk[bone_count]; // zero
	Matrix4x4F bone_matrices[bone_count];
	PString32 bone_names[bone_count];
};

Mesh mesh @ 0;
