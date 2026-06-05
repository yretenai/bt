// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma once
#pragma author Neptuwunium
#pragma description Neptuwunium String

import std.string;

struct CString<TChar> {
	TChar data[];
} [[format("format_string"), sealed]];

using CString8 = CString<char>;
using CString16 = CString<char16>;

struct CFixString<auto Size, TChar> {
	TChar data[Size];
} [[format("format_string"), sealed]];

using CFixString8<auto Size> = CFixString<Size, char>;
using CFixString16<auto Size> = CFixString<Size, char16>;

struct PString<TLen, TChar> {
	TLen length;
	TChar data[length];
} [[format("format_string"), sealed]];

using PString8 = PString<u8, char>;
using PString16 = PString<u16, char>;
using PString32 = PString<u32, char>;
using PString64 = PString<u64, char>;

fn format_string(ref auto pstr) {
	return std::format("\"{}\"", pstr.data);
};
