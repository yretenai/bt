// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine NuData
#pragma magic [ 4E 44 50 33 ] @ 0x00
#pragma endian big

import std.mem;

#include "Flight.hexpat"

struct Bounds {
	Vector3F pos;
	float radius;
};

/*
	U = UV (2 component)
	C = Color (4 component)
	P = position (3 component)
	N = normal (3 component)
	B = binormal (3 component)
	T = tangent (4 component)
	I = bone index (N component, 16 size)
	W = bone weight (N component)
*/

enum VertexUVType : u8 {
	U16 = 0x0,
	U32 = 0x1,
	C8U16 = 0x2,
	C8U32 = 0x3,
	C16U16 = 0x4,
	C16U32 = 0x5,
};

enum VertexGeomteryType : u8 {
	P32 = 0x0,
	P32N32 = 0x1,
	P32NB32 = 0x2,
	P32NBT32 = 0x3,
	P32N11 = 0x4,
	P32NBT11 = 0x5,
	P32N16 = 0x6,
	P32NBT16 = 0x7,
	P16N16 = 0x8,
};

enum VertexSkinType : u8 {
	BonelessChickenWings = 0x0,
	I4W16 = 0x1,
	I4W32 = 0x2,
	I8W16 = 0x3,
	I8W32 = 0x4,
};

bitfield VertexType {
	VertexSkinType skin_type: 4;
	VertexGeomteryType geometry_type: 4;
	uv_count: 4;
	VertexUVType uv_color: 4;
};

struct Primitive {
	u32 start = 0;
	u32 string_ptr = parent.parent.string_ptr;

	u32 index_offset;
	u32 vertex_offset;
	u32 skin_vertex_offset;
	u16 vertex_count;
	VertexType vertex_type;
	NuPtr<NUDMaterial> material_offset[4];
	u16 face_count;
	u16 attributes;
	u32 unknown_index_offset;
	u32 unknown_size;
	u32 unknown_vertex_offset;
};

struct Object {
	Bounds bounds;
	Vector3F pos;
	float bias;
	u32 name_offset;
	u16 reserved;
	u16 attributes;
	u16 mnt_index;
	u16 primitive_count;
	u32 primitive_offset;

	CString8 name @ parent.string_ptr + name_offset;

	Primitive primitives[primitive_count] @ primitive_offset;
};

struct NUD {
	u32 magic;
	u32 size;
	u8 version[2];
	u16 count;
	u16 min;
	u16 max;
	u32 object_size;
	u32 index_size;
	u32 vertex_size;
	u32 skin_vertex_size;
	Bounds bounds;

	u32 start = $;
	u32 string_ptr = $ + object_size + index_size + vertex_size + skin_vertex_size;
	Object objects[count];
	$ = start + object_size;
	u16 index_buffer[index_size / 2]; // triangle strip yippee!! new strips are made with 0xFFFF
	u8 vertex_buffer[vertex_size];
	u8 skin_vertex_buffer[skin_vertex_size]; // bone information is in MOP
};

NUD nud @ 0;
