// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description FlyFF WindEngine Animations

#include "FlyFF.hexpat"

struct Animation {
	bool use_global_matrix = true;

	s32 version;
	u32 id;
	float slerp;
	s32 reserved[8];
	s32 bone_count;
	s32 frame_count;

	bool has_paths [[fixed_size(4)]];
	if (has_paths) {
		Vector3F paths[frame_count];
	}

	Motion data;
	MotionAttribute attributes[frame_count];

	s32 event_count;
	if (event_count > 0) {
		Vector3F events[event_count];
	}
};

Animation ani @ 0;
