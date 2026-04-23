// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma once
#pragma author Neptuwunium
#pragma description FlyFF Common Types

#include "NeptuwuniumMath.hexpat"
#include "NeptuwuniumInt.hexpat"

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
	uint32_t type;
	int32_t sound_id;
	float frame;
};

struct Bone {
	PString32 name;

	if (parent.use_global_matrix) {
		Matrix4x4F matrix;
	}

	Matrix4x4F inverse_matrix;
	Matrix4x4F local_matrix;
	int32_t parent_id;
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
	int32_t bone_count = parent.bone_count;
	int32_t frame_count = parent.frame_count;
	bool use_global_matrix = false;

	Bone bones[bone_count];
	int32_t animation_count;
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

enum GameObjectType : uint16_t {
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
	Vector2<int16_t> index;
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
	int32_t start_vertex;
	int32_t primitive_count;
	uint32_t material_id;
	uint32_t effect_id;
	int32_t amount;
	int32_t used_bone_count;
	int32_t bone_palette[28];
};

struct GameObjectInfo {
	AABBF bounds;
	bool is_transparent [[fixed_size(4)]];
	bool is_bump [[fixed_size(4)]];
	bool is_rigid [[fixed_size(4)]];
	int32_t reserved[7] [[hidden]];
	int32_t vertex_list_count;
	int32_t vertex_count;
	int32_t index_list_count;
	int32_t index_count;
	Vector3F vertex_list[vertex_count];

	if (parent.object_type == GameObjectType::Skin) {
		SkinVertex vertices[vertex_count];
	} else {
		NormalVertex vertices[vertex_count];
	}

	uint16_t indices[index_count];
	uint16_t iib[vertex_count];

	bool has_physique [[fixed_size(4)]];
	if (has_physique) {
		uint32_t physique_vertices[vertex_list_count];
	}

	bool has_material [[fixed_size(4)]];
	if (has_material) {
		int32_t material_count;
		Material materials[material_count == 0 ? 1 : material_count];
	}

	int32_t material_block_count;
	if (material_block_count > 0) {
		MaterialBlock material_blocks[material_block_count];
	}
};

struct GameObject {
	GameObjectType object_type;

	int32_t used_bone_count;
	if (used_bone_count > 0) {
		int32_t used_bones[used_bone_count];
	}

	int32_t id;
	int32_t parent_id;
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
	int32_t frame_count = parent.frame_count;
	int32_t object_count;
	GameObject objects[object_count];
};
