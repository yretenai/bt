// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description NeoX Mesh File
#pragma magic [ 34 80 C8 BB ] @ 0x00

import std.mem;

#include "Neptuwunium.hexpat"

struct NxName {
	u8 data[0x20];
} [[format("format_string")]];

struct NxPoseBone {
	Vector4F rot;
	Vector3F pos;
};

struct NxBoneData {
	u16 count;
	s8 palette[count];
	NxName names[count];
	bool has_bind_pose;
	if (has_bind_pose) {
		NxPoseBone pose[count];
	}
	Matrix4x4F matrices[count];
};

struct NxKeyTimes {
	u16 key_count;
	float keys[key_count];
};

struct NxMorphData {
	u8 target;
	NxKeyTimes key_times;
};

struct NxAnim {
	NxName name;
	u8 unknown1;
	u8 unknown2;
	u8 unknown3;
	u8 unknown4;
	NxKeyTimes time;
	u16 track_count;

	// todo
};

struct NxAnimData {
	u32 count;
	NxAnim animations[count];
};

struct NxBonePose {
	u8 count;
	NxPoseBone pose[count];
};

struct NxSubmeshInfo {
	u32 vertex_count;
	u32 face_count;
	u8 uv_count;
	u8 color_count;
};

struct NxMeshData {
	u32 size;
	NxSubmeshInfo submeshes[while(std::mem::read_unsigned($, 2) != 0x1)];
	u16 stop [[hidden]];
	u32 vertex_count;
	u32 index_count;
	Vector3F xyz[vertex_count];
	Vector3F nxyz[vertex_count];
	u16 has_tangent;
	if (has_tangent > 0) {
		Vector3F txyz[vertex_count];
	}
	u16 faces[index_count * 3];
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
