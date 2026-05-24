// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description World of Warships Moo Geometry

#include "Neptuwunium.hexpat"

struct GeometryHeader {
	s32 vertex_buffer_count;
	s32 index_buffer_count;
	s32 vertex_name_count;
	s32 index_name_count;
	s32 collision_buffer_count;
	s32 armor_buffer_count;

	s64 ptr_vertex_names;
	s64 ptr_index_names;
	s64 ptr_vertex_buffers;
	s64 ptr_index_buffers;
	s64 ptr_collision_buffers;
	s64 ptr_armor_buffers;
};

struct NameEntry {
	u32 name_hash;
	u16 buffer_index;
	u16 mesh_id;
	s32 buffer_offset;
	s32 buffer_length;
};

struct VertexBuffer {
	u64 pos = addressof(this);

	s64 ptr_buffer;
	s64 vertex_format_length;
	s64 ptr_vertex_format;
	s32 buffer_length;
	s16 vertex_stride;
	bool is_skinned;
	bool has_tangent;

	CFixString<vertex_format_length> vertex_format @ pos + 8 + ptr_vertex_format; // usually ENCD data
	u8 buffer[buffer_length] @ pos + ptr_buffer;
};

struct IndexBuffer {
	u64 pos = addressof(this);

	s64 ptr_buffer;
	s32 buffer_length;
	u16 unknown;
	s16 index_stride;

	u8 buffer[buffer_length] @ pos + ptr_buffer; // usually ENCD data
};

struct BasicBuffer<Type> {
	u64 pos = addressof(this);

	s64 buffer_length;
	s64 name_length;
	s64 ptr_name;
	s64 ptr_buffer;

	CFixString<name_length> name @ pos + 8 + ptr_name;
	Type armor @ pos + ptr_buffer;
};

struct ArmorVertex {
	Vector3F position;
	Vector4F normal;
};

struct ArmorPlate {
	u16 thickness;
	u16 id;
	AABBF bounding_box;
	s32 vertex_count;
	ArmorVertex vertices[vertex_count];
};

struct ArmorBlock {
	u32 id;
	AABBF bounding_box;
	s32 plate_count;
	ArmorPlate plates[plate_count];
};

using ArmorBuffer = BasicBuffer<ArmorBlock>;

struct CollisionConvexPolygon {
	s32 count;
	u32 adjacent_faces[count];
	u32 perimeter_faces[count];

	if(parent.parent.version > 0x26092011) {
		u32 physics_mask;
	}
};

struct CollisionConvexHull {
	s32 vertex_count;
	Vector3F vertices[vertex_count];

	s32 edge_count;
	s32 edges[edge_count * 2];

	s32 polygon_count;
	CollisionConvexPolygon polygons[polygon_count];
};

struct CollisionMesh {
	u32 version;
	s32 count;
	CollisionConvexHull hulls[count];
};

using CollisionBuffer = BasicBuffer<CollisionMesh>;

struct Geometry {
	GeometryHeader header;

	NameEntry vertex_names[header.vertex_name_count] @ header.ptr_vertex_names;
	NameEntry index_names[header.index_name_count] @ header.ptr_index_names;
	VertexBuffer vertex_buffers[header.vertex_buffer_count] @ header.ptr_vertex_buffers;
	IndexBuffer index_buffers[header.index_buffer_count] @ header.ptr_index_buffers;
	CollisionBuffer collision_buffers[header.collision_buffer_count] @ header.ptr_collision_buffers;
	ArmorBuffer armor_buffers[header.armor_buffer_count] @ header.ptr_armor_buffers;
};

Geometry file;
