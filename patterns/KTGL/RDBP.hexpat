// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description KTGL Resource Database Package
#pragma magic [ 50 44 52 4B 30 30 30 30 ] @ 0x00

#pragma array_limit 0xffffffff
#pragma pattern_limit 0xffffffff

#include "KTGL.hexpat"

struct RDBPackage {
	KTGLHeader header;
	u32 file_size;
};

struct RDBPackageData {
	RDBIndex inner [[inline]];
	u8 data[inner.disk_size];
	std::mem::AlignTo<16>;
};

RDBPackage root @ 0;
RDBPackageData index[while($ < root.file_size)] @ root.size;
