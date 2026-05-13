// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description NeoX Mesh File
#pragma magic [ 34 80 C8 BB ] @ 0x00

import std.mem;

#include "NeptuwuniumInt.hexpat"
#include "NeptuwuniumMath.hexpat"

struct NxName {
	uint8_t data[0x20];
} [[format("format_string")]];

struct NxPoseBone {
	Vector4F rot;
	Vector3F pos;
};

struct NxBoneData {
	uint16_t count;
	int8_t palette[count];
	NxName names[count];
	bool has_bind_pose;
	if (has_bind_pose) {
		NxPoseBone pose[count];
	}
	Matrix4x4F matrices[count];
};

struct NxKeyTimes {
	uint16_t key_count;
	float keys[key_count];
};

struct NxMorphData {
	uint8_t target;
	NxKeyTimes key_times;
};

struct NxAnim {
	NxName name;
	uint8_t unknown1;
	uint8_t unknown2;
	uint8_t unknown3;
	uint8_t unknown4;
	NxKeyTimes time;
	uint16_t track_count;

	// todo
};

struct NxAnimData {
	uint32_t count;
	NxAnim animations[count];
};

struct NxBonePose {
	uint8_t count;
	NxPoseBone pose[count];
};

struct NxSubmeshInfo {
	uint32_t vertex_count;
	uint32_t face_count;
	uint8_t uv_count;
	uint8_t color_count;
};

struct NxMeshData {
	uint32_t size;
	NxSubmeshInfo submeshes[while(std::mem::read_unsigned($, 2) != 0x1)];
	uint16_t stop [[hidden]];
	uint32_t vertex_count;
	uint32_t index_count;
	Vector3F xyz[vertex_count];
	Vector3F nxyz[vertex_count];
	uint16_t has_tangent;
	if (has_tangent > 0) {
		Vector3F txyz[vertex_count];
	}
	uint16_t faces[index_count * 3];
	Vector2F uv[vertex_count * 2]; // actually sum(submeshes[n].uvCount * submeshes[n].vertex_count)
	Color32 color[vertex_count]; // actually sum(submeshes[n].colorCount * submeshes[n].vertex_count)

	if (parent.skeleton_count > 0) { // game checks if skeleton_count == 1
		Color32 joints[vertex_count];
		Vector4F weights[vertex_count];
	}

	// todo: some extra stuff
} [[hex::visualize("3d", xyz, faces, nxyz, null, null)]];

struct NxMeshHeader {
	u32 magic;
	u32 version;
	u16 skeleton_count;

	bool has_morph;
	if (has_morph) {
		NxMorphData morph;
	}

	bool has_anim;
	if (has_anim) {
		NxAnimData anim;
	}

	if (skeleton_count > 0) { // game checks skeleton_count == 1
		NxBoneData bone;

		bool has_bone_pose;
		if (has_bone_pose) {
			NxBonePose pose;
		}
	}

	NxMeshData mesh_data;
};

NxMeshHeader header @ 0;
