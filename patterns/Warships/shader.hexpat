// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

agma author Neptuwunium
#pragma description World of Warships Moo Shader
#pragma magic [ 41 52 49 45 ] @ 0
#pragma magic [ 41 52 49 53 ] @ 0

#include "Neptuwunium.hexpat"

struct ShaderPackHeader {
	u32 magic; // ARIE / ARIS
	u32 sys_platform; // WIN\x20
	u32 gfx_platform; // DX11
	u32 version; // 8
	u32 hash;
};

struct ShaderPackTablePtrs {
	u32 reserved; // 0?
	s32 strt;
	s32 tbb;
	s32 ubb;
	s32 stb;
	s32 srvs;
	s32 uavs;
	s32 rtb;
	s32 ech;
	s32 std;
	s32 rstd;
	s32 shader_table;
	s32 atb;
	s32 code;
	s32 data;
	s32 unknown;
};

struct ShaderPack {
	ShaderPackHeader header;
	ShaderPackTablePtrs ptrs;
};

struct ShaderBlob {
	ShaderPackHeader header;
	u64 hash;
	s32 param_table_offset;
	s32 shader_type;
	s32 quality;
	s32 shader_offset; // might be nr of params?
	s32 shader_length;
	s32 unknown_offset2;
	s32 unknown_offset3;
	u8 shader[shader_length];
};

ShaderPack shader;
ShaderBlob blob;
