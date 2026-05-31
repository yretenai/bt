// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description PhysX TriMesh
#pragma magic [ 4E 58 53 01 4D 45 53 48 ] @ 0x00

#include "PhysX.hexpat"
#include "Neptuwunium.hexpat"


enum BVHVersion : u32 {
	BVH33 = 0,
	BVH34 = 1
};

bitfield MeshSerialFlags {
	materials : 1;
	face_remap : 1;
	uint8_indices : 1;
	uint16_indices : 1;
	adjacencies : 1;
	grb : 1;
	sdf : 1;
	vert_mapping : 1;
	grb_inv_remap : 1;
	inertia : 1;
} [[fixed_size(4)]];

struct Indices<auto serial_flags, auto count> {
	if (serial_flags.uint8_indices) {
		u8 indices[count];
	} else if (serial_flags.uint16_indices) {
		u16 indices[count];
	} else {
		u32 indices[count];
	}
};

struct BVH33Page {
	Vector4F minx;
	Vector4F miny;
	Vector4F minz;
	Vector4F maxx;
	Vector4F maxy;
	Vector4F maxz;
	Vector4<u32> ptrs;
};

struct BVH33 {
	u32 chunkId;
	u32 version;

	Vector4F bounds_min;
	Vector4F bounds_max;
	Vector4F inv_diagonal;
	Vector4F diagonal_scaler;

	u32 page_size;
	u32 num_root_pages;
	u32 num_levels;
	u32 total_nodes;
	u32 total_pages;
	u32 reserved;
	BVH33Page pages[total_pages];
};

struct BVH34QuantizedAABB {
	u16 extents;
	u16 center;
};

struct BVH34Node<T> {
	T aabb;
	u32 data;
};

struct BVH34 {
	u32 chunkId;
	u32 version;

	Vector3F center;
	float extent;
	u32 init_data;
	Vector3F min_coeff;
	Vector3F max_coeff;

	if (version >= 3) {
		bool quantized [[fixed_size(4)]];
	} else {
		bool quantized = true;
	}

	u32 node_count;

	if (quantized) {
		BVH34Node<Vector3<BVH34QuantizedAABB>> nodes[node_count];
	} else {
		BVH34Node<AABBF> nodes[node_count];
	}
};

struct NovodexMesh {
	NovodexHeader header;
	u32 version = header.version;

	if (version >= 14) {
		BVHVersion midphase_id;
	} else {
		BVHVersion midphase_id = BVHVersion::BVH33;
	}

	MeshSerialFlags serial_flags;

	if (version <= 12) {
		float convex_edge_threshold;
	}

	u32 vertex_count;
	u32 tri_count;

	Vector3F vertices[vertex_count];

	Indices<serial_flags, tri_count * 3> indices;

	if (serial_flags.materials) {
		u16 material_indices[tri_count];
	}

	if (serial_flags.face_remap) {
		u32 remap_max;
		Indices<serial_flags, tri_count> remap_indices;
	}

	if (serial_flags.adjacencies) {
		u32 adjacencies[tri_count * 3];
	}

	if (midphase_id == BVHVersion::BVH33) {
		BVH33 bvh;
	} else if(midphase_id == BVHVersion::BVH34) {
		BVH34 bvh;
	}

	float epsilon;
	AABBF aabb;

	u32 extra_triangle_count;
	u8 extra_triangle_data[extra_triangle_count];

	// grb
	// sdf
	// inertia
} [[hex::visualize("3d", vertices, indices.indices, null, null, null)]];
