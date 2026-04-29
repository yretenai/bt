// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#include "NeptuwuniumInt.hexpat"

using KTID = uint32_t [[format_read("format_ktid")]];

fn format_ktid(ref KTID id) {
	return std::format("{:08x}", id);
};

enum KTGLPlatform : uint32_t {
	Generic,
	PS3,
	X360,
	NWii,
	NDS,
	N3DS,
	PSVita,
	Android,
	iOS,
	NWiiU,
	Generic64,
	PS4,
	XBO,
	Unknown13,
	WinD3D12,
	Unknown15,
	NSwitch,
	Unknown17,
	Unknown18,
	PS5,
	XSX,
};

struct KTGLHeader {
	uint32_t magic;
	uint32_t version;
	uint32_t size;
};

enum RDBStorageType : uint8_t {
	None,
	Zlib, // 32-bit block disk size + zlib data
	Lz4, // 32-bit block disk size + lz4 data
	XorZlib, // XOR(Zlib)
	ChecksumZlib, // 16-bit block disk size + 64-bit checksum + block data
};

enum RDBLocationType : uint8_t {
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

enum OBJDBPropertyType : uint32_t {
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
	int count;
	KTID property_id;
};

struct RDBIndex {
	KTGLHeader header;
	uint32_t align [[hidden]];
	uint64_t disk_size;
	uint64_t memory_size;
	uint32_t property_size;
	KTID name_id;
	KTID type_id;
	RDBFlags flags;
	KTID resource_Id;
	uint32_t property_count;

	IDSOBJDBProperty properties[property_count];
	uint8_t property_values[property_size];
};
