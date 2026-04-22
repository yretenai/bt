#pragma author Neptuwunium
#pragma description FlyFF WindEngine Animations

#include "FlyFF/FlyFF.hexpat"

struct Animation {
	bool use_global_matrix = true;

	int32_t version;
	uint32_t id;
	float slerp;
	int32_t reserved[8];
	int32_t bone_count;
	int32_t frame_count;

	bool has_paths [[fixed_size(4)]];
	if (has_paths) {
		Vector3F paths[frame_count];
	}

	Motion data;
	MotionAttribute attributes[frame_count];

	int event_count;
	if (event_count > 0) {
		Vector3F events[event_count];
	}
};

Animation ani @ 0;
