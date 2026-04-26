// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description World of Warships Moo Geometry

#include "NeptuwuniumInt.hexpat"
#include "NeptuwuniumMath.hexpat"

struct GeometryHeader {
	int32_t vertex_buffer_count;
	int32_t index_buffer_count;
	int32_t vertex_name_count;
	int32_t index_name_count;
	int32_t collision_buffer_count;
	int32_t armor_buffer_count;

	int64_t ptr_vertex_names;
	int64_t ptr_index_names;
	int64_t ptr_vertex_buffers;
	int64_t ptr_index_buffers;
	int64_t ptr_collision_buffers;
	int64_t ptr_armor_buffers;
};

struct NameEntry {
	uint32_t name_hash;
	uint16_t buffer_index;
	uint16_t mesh_id;
	int32_t buffer_offset;
	int32_t buffer_length;
};

struct VertexBuffer {
	uint64_t pos = addressof(this);

	int64_t ptr_buffer;
	int64_t vertex_format_length;
	int64_t ptr_vertex_format;
	int32_t buffer_length;
	int16_t vertex_stride;
	bool is_skinned;
	bool has_tangent;

	char vertex_format[vertex_format_length] @ pos + 8 + ptr_vertex_format; // usually ENCD data
	uint8_t buffer[buffer_length] @ pos + ptr_buffer;
};

struct IndexBuffer {
	uint64_t pos = addressof(this);

	int64_t ptr_buffer;
	int32_t buffer_length;
	uint16_t unknown;
	int16_t index_stride;

	uint8_t buffer[buffer_length] @ pos + ptr_buffer; // usually ENCD data
};

struct BasicBuffer<Type> {
	uint64_t pos = addressof(this);

	int64_t buffer_length;
	int64_t name_length;
	int64_t ptr_name;
	int64_t ptr_buffer;

	char name[name_length] @ pos + 8 + ptr_name;
	Type armor @ pos + ptr_buffer;
};

struct ArmorVertex {
	Vector3F position;
	Vector4F normal;
};

struct ArmorPlate {
	uint16_t thickness;
	uint16_t id;
	AABBF bounding_box;
	int32_t vertex_count;
	ArmorVertex vertices[vertex_count];
};

struct ArmorBlock {
	uint32_t id;
	AABBF bounding_box;
	int32_t plate_count;
	ArmorPlate plates[plate_count];
};

using ArmorBuffer = BasicBuffer<ArmorBlock>;

struct CollisionConvexPolygon {
	int32_t count;
	uint32_t adjacent_faces[count];
	uint32_t perimeter_faces[count];

	if(parent.parent.version > 0x26092011) {
		uint32_t physics_mask;
	}
};

struct CollisionConvexHull {
	int32_t vertex_count;
	Vector3F vertices[vertex_count];

	int32_t edge_count;
	int32_t edges[edge_count * 2];

	int32_t polygon_count;
	CollisionConvexPolygon polygons[polygon_count];
};

struct CollisionMesh {
	uint32_t version;
	int32_t count;
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
