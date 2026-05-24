// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#include "Neptuwunium.hexpat"

using KTID = u32 [[format_read("format_ktid")]];

fn format_ktid(ref KTID id) {
	return std::format("{:08x}", id);
};

enum KTGLPlatform : u32 {
	D3D9,
	PS3,
	X360,
	RVL,
	NTR,
	CTR,
	NGP,
	Android,
	iOS,
	Cafe,
	D3D11,
	PS4,
	XBO,
	Unknown13,
	D3D12,
	Unknown15,
	NSwitch,
	Unknown17,
	Unknown18,
	PS5,
	XSX,
};

struct KTGLHeader {
	u32 magic;
	u32 version;
	u32 size;
};

enum RDBStorageType : u8 {
	None,
	Zlib, // 32-bit block disk size + zlib data
	Lz4, // 32-bit block disk size + lz4 data
	XorZlib, // XOR(Zlib)
	ChecksumZlib, // 16-bit block disk size + 64-bit checksum + block data
};

enum RDBLocationType : u8 {
	Virtual,
	External,
	Internal
};

bitfield RDBFlags {
	unknown1 : 16;
	RDBLocationType location_type : 4;
	RDBStorageType storage_type : 4;
	unknown2 : 4; // some indexer
	unknown3 : 2;
	unknown4 : 2;
} [[fixed_size(4)]];

enum OBJDBPropertyType : u32 {
	Bool,
	Byte,
	Int16,
	UInt16,
	Int32,
	UInt32,
	Int64,
	UInt64,
	Float32,
	Float64,
	Vector4F,
	Matrix4F,
	Vector2F,
	Vector3F,
	None,
};

struct IDSOBJDBProperty {
	OBJDBPropertyType property_type;
	s32 count;
	KTID property_id;
};

struct RDBIndex {
	KTGLHeader header;
	KTGLPlatform platform;
	u64 disk_size;
	u64 memory_size;
	u32 property_size;
	KTID name_id;
	KTID type_id;
	RDBFlags flags;
	KTID resource_Id;
	u32 property_count;

	IDSOBJDBProperty properties[property_count];
	u8 property_values[property_size];
};
