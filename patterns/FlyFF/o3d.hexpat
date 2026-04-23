// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description FlyFF WindEngine Object3D

#include "FlyFF.hexpat"

struct Object3D {
	ObfuscatedString name;
	int32_t version;
	uint32_t id;
	Force forces;
	Vector2F scroll_uv;
	Vector4F center;
	AABBF bounds;
	float slerp;
	int32_t frame_count;

	int32_t event_count;
	if (event_count > 0) {
		Vector3F events[event_count];
	}

	bool has_collision [[fixed_size(4)]];
	if (has_collision) {
		CollisionObject collision;
	}

	bool has_lod [[fixed_size(4)]];

	int32_t bone_count;
	if (bone_count > 0) {
		Matrix4x4F bone_matrices[bone_count];
		Matrix4x4F bone_inverse_matrices[bone_count];

		if (frame_count > 0) {
			Motion frames[frame_count];
		}

		bool send_vs [[fixed_size(4)]];
	}

	int32_t game_object_count;
	LODGroup lods[has_lod ? 3 : 1];

	if (frame_count > 0) {
		if (version >= 21) {
			int32_t attribute_count;
			MotionAttribute frame_attributes[attribute_count];
		} else {
			MotionAttribute frame_attributes[frame_count];
		}
	}
};

Object3D o3d @ 0;
