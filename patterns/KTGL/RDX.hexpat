// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description KTGL RDX Resource Link
#pragma magic [ 00 00 FF FF ?? ?? ?? ?? 01 00 FF FF ] @ 0x00

#include "KTGL.hexpat"

struct RBXEntry {
	u16 index;
	u8 mount_index;
	u8 locale_index;
	KTID file_id;
} [[format_read("format_rbx")]];

fn format_rbx(ref RBXEntry rbx) {
	str path = "";

	if (rbx.mount_index != 0xFF) {
		path += std::format("MountPoint_{}/", rbx.mount_index);
	}

	if (rbx.locale_index != 0xFF) {
		path += "enUS/";
	}

	return std::format("{}0x{:08x}.fdata ({:04x})", path, rbx.file_id, rbx.index);
};

RBXEntry entries[while($ < std::mem::size())] @ 0x0;
