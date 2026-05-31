// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description HEAT TriMesh

#include "PhysX/trimesh.hexpat"

struct MatKind {
	u8 uuid[16];
	u32 count;
	u8 armor_groups[count];
};

struct TriMesh {
	u32 matkind_offset;
	NovodexMesh trimesh;
	MatKind matkind @ matkind_offset + 4;
};

TriMesh trimesh @ 0;
