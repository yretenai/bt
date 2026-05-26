// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma once
#pragma author Neptuwunium
#pragma description FlyFF Types

#include "Neptuwunium.hexpat"

struct ObfuscatedString {
	u8 length;
	u8 data[length];
} [[format("format_obfstr")]];

fn format_obfstr(ref ObfuscatedString v) {
	str result = "";
	for (u32 i = 0, i < v.length, i += 1) {
		result += char(v.data[i] ^ 0xCD);
	}
	return result;
};

struct AnimationFrame {
	Vector4F rotation;
	Vector3F position;
};

struct MotionAttribute {
	u32 type;
	s32 sound_id;
	float frame;
};

struct Bone {
	PString32 name;

	if (parent.use_global_matrix) {
		Matrix4x4F matrix;
	}

	Matrix4x4F inverse_matrix;
	Matrix4x4F local_matrix;
	s32 parent_id;
};

struct BoneAnimation {
	bool has_keyframes [[fixed_size(4)]];
	if (has_keyframes) {
		AnimationFrame frames[parent.frame_count];
	} else {
		Matrix4x4F pose;
	}
};

struct Motion {
	s32 bone_count = parent.bone_count;
	s32 frame_count = parent.frame_count;
	bool use_global_matrix = false;

	Bone bones[bone_count];
	s32 animation_count;
	BoneAnimation animations[bone_count];
};

struct Force {
	Vector3F force0;
	Vector3F force1;

	if (parent.version >= 22) {
		Vector3F force2;
		Vector3F force3;
	}
};

enum GameObjectType : u16 {
	Normal,
	Skin,
	Bone,
	Light = 0x8000,
	Invalid = 0xffff
} [[fixed_size(4)]];

struct NormalVertex {
	Vector3F position;
	Vector3F normal;
	Vector2F uv;
};

struct SkinVertex {
	Vector3F position;
	Vector2F weight;
	Vector2<s16> index;
	Vector3F normal;
	Vector2F uv;
};

struct CollisionVertex {
	Vector3F position;
	Color32 color;
};

struct Material {
	Vector4F diffuse;
	Vector4F ambient;
	Vector4F specular;
	Vector4F emissive;
	float emissive_power;
	PString32 texture_name;
};

struct MaterialBlock {
	s32 start_vertex;
	s32 primitive_count;
	u32 material_id;
	u32 effect_id;
	s32 amount;
	s32 used_bone_count;
	s32 bone_palette[28];
};

struct GameObjectInfo {
	AABBF bounds;
	bool is_transparent [[fixed_size(4)]];
	bool is_bump [[fixed_size(4)]];
	bool is_rigid [[fixed_size(4)]];
	s32 reserved[7] [[hidden]];
	s32 vertex_list_count;
	s32 vertex_count;
	s32 index_list_count;
	s32 index_count;
	Vector3F vertex_list[vertex_count];

	if (parent.object_type == GameObjectType::Skin) {
		SkinVertex vertices[vertex_count];
	} else {
		NormalVertex vertices[vertex_count];
	}

	u16 indices[index_count];
	u16 iib[vertex_count];

	bool has_physique [[fixed_size(4)]];
	if (has_physique) {
		u32 physique_vertices[vertex_list_count];
	}

	bool has_material [[fixed_size(4)]];
	if (has_material) {
		s32 material_count;
		Material materials[material_count == 0 ? 1 : material_count];
	}

	s32 material_block_count;
	if (material_block_count > 0) {
		MaterialBlock material_blocks[material_block_count];
	}
};

struct GameObject {
	GameObjectType object_type;

	s32 used_bone_count;
	if (used_bone_count > 0) {
		s32 used_bones[used_bone_count];
	}

	s32 id;
	s32 parent_id;
	if (parent_id != -1) {
		GameObjectType parent_object_type;
	}

	Matrix4x4F transform;

	GameObjectInfo info;

	if (object_type == GameObjectType::Normal && parent.frame_count > 0) {
		bool has_frames [[fixed_size(4)]];
		if (has_frames) {
			AnimationFrame frames[parent.frame_count];
		}
	}
};

struct CollisionObject {
	GameObjectType object_type = GameObjectType::Normal;
	GameObjectInfo info;
};

struct LODGroup {
	s32 frame_count = parent.frame_count;
	s32 object_count;
	GameObject objects[object_count];
};
