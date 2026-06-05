// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#include "Neptuwunium.hexpat"

struct RelPtr<T> {
	u32 offset;

	if (offset > 0) {
		T value @ offset + $ [[inline]];
	}
};

struct BonePtr<T> {
	u32 offset;

	if (offset > 0) {
		T value @ offset + parent.headerEnd [[inline]];
	}
};

struct BoneData {
	Matrix4x4F matrices[parent.parent.boneCount];
	PString32 names[parent.parent.boneCount];
};

struct BoneChild {
	u32 relPtr;
	u32 boneId;
};

struct BoneInfo {
	u16 parentIndex;
	u16 unknown;
	u32 childCount;

	if (childCount > 0) {
		BoneChild children[childCount];
	}

	u32 parentOffset; // doesn't exist on the last one.
} [[inline]];

struct Skeleton {
	u32 version;
	u16 boneCount;
	RelPtr<BoneData> boneData;
	u32 headerEnd = $ + 4;
	BonePtr<BoneInfo> bones[boneCount];
	BonePtr<BoneInfo> rootBone;
};
