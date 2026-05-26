// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description ACI MATE Material
#pragma magic [ 4D 41 54 45 ] @ 0x00
#pragma endian big

#include "Flight.hexpat"

struct Material {
	u32 start = 0;
	u32 string_ptr = 0;

	NuPtr<NUDMaterial> nud_material;
	u8 reserved[8];
	u32 first_object_index;
};

struct Primitive {
	u16 primitive_index;
	u16 material_index;
	u8 reserved[0xc];
};

struct Object {
	u16 primitive_count;
	u16 first_primitive_index;
	u8 reserved[4];
};

struct MAT {
	u32 magic;
	u16 material_count;
	u16 primitive_count;
	u16 object_count;
	u16 reserved;
	u32 material_offset;
	u32 primitive_offset;
	u32 object_offset;
	u8 reserved2[8];
	u32 flags;
	u8 reserved3[0xc];

	Material materials[material_count] @ material_offset;
	Primitive primitives[primitive_count] @ primitive_offset;
	Object objects[object_count] @ object_offset;
};

MAT mat @ 0;
