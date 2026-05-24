// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#include "Neptuwunium.hexpat"

using HashId = u32 [[format_read("format_hashid")]];

fn format_hashid(ref HashId id) {
	return std::format("[0x{:08x}]", id);
};

struct ACEHeader {
	u8 magic[3]; // "D", "P", "L" or "F", "H", "M"
	bool is_big_endian;
	u32 version; // 20101010 = 2010-10-10
	u32 date; // yyyymmddxx
};

enum FHMMemoryType : u16 {
	CPU,
	GPU,
	SHARED,
	COUNT,
};

struct NuPtr<T> {
	u32 offset [[hidden]];
	if (offset > 0) {
		T value @ offset + parent.start [[inline]];
	}
};

struct NUDTexture {
	u32 index; // NUT GIDX entry
	u32 reserved; // engine writes the address to NUT here
	u16 reserved2; // engine writes flags relating to loaded NUT
	u16 attributes;
	u8 wrap_u;
	u8 wrap_v;
	u8 wrap_w;
	u8 mag;
	u8 min;
	u8 mip;
	u8 ansio;
	u8 reserved3; // set to 1 by runtime if not valid
	float bias;
};

struct NUDShaderParam {
	u32 pos = $;

	u32 next;
	u32 name_offset;
	u32 param_count;
	u32 reserved2;

	u32 param_u32[param_count] @ $ [[no_unique_address]];
	float param_f32[param_count] @ $ [[no_unique_address]];

	u32 string_ptr = parent.string_ptr;
	CString8 name @ string_ptr + name_offset;

	if (next > 0) {
		NUDShaderParam nextParam @ pos + next;
	}
};

struct NUDMaterial {
	u32 index;
	u32 reserved;
	u16 attributes;
	u16 texture_count;
	u16 alpha_blend;
	u16 alpha_test_func;
	u16 alpha_test_ref;
	u16 cull_mode;
	u32 reserved2;
	float offset_scale;
	float offset_bias;

	u32 string_ptr = parent.parent.string_ptr;

	NUDTexture textures[texture_count];
	NUDShaderParam params;
};
