// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

agma author Neptuwunium
#pragma description World of Warships Moo Shader
#pragma magic [ 41 52 49 45 ] @ 0
#pragma magic [ 41 52 49 53 ] @ 0

#include "NeptuwuniumInt.hexpat"

struct ShaderPackHeader {
	uint32_t magic; // ARIE / ARIS
	uint32_t sys_platform; // WIN\x20
	uint32_t gfx_platform; // DX11
	uint32_t version; // 8
	uint32_t hash;
};

struct ShaderPackTablePtrs {
	uint32_t reserved; // 0?
	int32_t strt;
	int32_t tbb;
	int32_t ubb;
	int32_t stb;
	int32_t srvs;
	int32_t uavs;
	int32_t rtb;
	int32_t ech;
	int32_t std;
	int32_t rstd;
	int32_t shader_table;
	int32_t atb;
	int32_t code;
	int32_t data;
	int32_t unknown;
};

struct ShaderPack {
	ShaderPackHeader header;
	ShaderPackTablePtrs ptrs;
};

struct ShaderBlob {
	ShaderPackHeader header;
	uint64_t hash;
	int32_t param_table_offset;
	int32_t shader_type;
	int32_t quality;
	int32_t shader_offset; // might be nr of params?
	int32_t shader_length;
	int32_t unknown_offset2;
	int32_t unknown_offset3;
	uint8_t shader[shader_length];
};

ShaderPack shader;
ShaderBlob blob;
