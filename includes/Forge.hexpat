// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Forge Types

#include "Neptuwunium.hexpat"

struct ForgeString {
	u32 length;

	bool is_utf16 = (length & 0x20000000) != 0;
	bool is_xor_encrypted = (length & 0x40000000) != 0;
	bool is_aes_encrypted = (length & 0x80000000) != 0;
	bool is_encrypted = is_xor_encrypted || is_aes_encrypted;

	u32 actual_length = (length & 0x1fffffff) * (is_utf16 ? 2 : 1);

	if (is_encrypted) {
		u8 data[actual_length]; // encrypted
	} else {
		if (is_utf16) {
			CFixString16<actual_length> data;
		} else {
			CFixString8<actual_length> data;
		}
	}
} [[format("format_forge_string")]];

fn format_forge_string(ref ForgeString v) {
	if (v.is_encrypted) {
		return "(Encrypted)";
	}

	return v.data;
};
