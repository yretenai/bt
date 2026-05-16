// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description FlyFF WindEngine Skeletons

#include "FlyFF.hexpat"

struct Skeleton {
	bool use_global_matrix = true;

	s32 version;
	u32 id;
	s32 bone_count;
	Bone bones[bone_count];
	bool send_vs [[fixed_size(4)]];
	Matrix4x4F local_rh;
	Matrix4x4F local_shield;
	Matrix4x4F local_knuckle;

	if (version >= 5) {
		Vector3F events[version == 5 ? 4 : 8];
		s32 event_parent_ids[version == 5 ? 4 : 8];
	}

	if (version >= 7) {
		Matrix4x4F local_lh;
	}
};

Skeleton skl @ 0;
