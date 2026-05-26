// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma once
#pragma author Neptuwunium
#pragma description Neptuwunium Integer

import type.float16;

// stdint

using int8_t = s8;
using uint8_t = u8;
using int16_t = s16;
using uint16_t = u16;
using int24_t = s24;
using uint24_t = u24;
using int32_t = s32;
using uint32_t = u32;
using int48_t = s48;
using uint48_t = u48;
using int64_t = s64;
using uint64_t = u64;
using intptr_t = s64;
using uintptr_t = u64;
using half = type::float16;

// csharp

using byte = s8;
using sbyte = u8;
using short = s16;
using ushort = u16;
using Int24 = s24;
using UInt24 = u24;
using int = s32;
using uint = u32;
using Int48 = s48;
using UInt48 = u48;
using long = s64;
using ulong = u64;
using nint = intptr_t;
using nuint = uintptr_t;
using Half = half;

// non-aligned ints

struct uint40_t {
	u8 value[5] [[format_read("read_uint40")]];
} [[inline]];

using u40 = uint40_t;
using UInt40 = uint40_t;

struct int40_t {
	u8 value[5] [[format_read("read_int40")]];
} [[inline]];

using s40 = int40_t;
using Int40 = int40_t;

struct uint58_t {
	u8 value[7] [[format_read("read_uint58")]];
} [[inline]];

using u58 = uint58_t;
using UInt58 = uint58_t;

struct int58_t {
	u8 value[7] [[format_read("read_int58")]];
} [[inline]];

using s58 = int58_t;
using Int58 = int58_t;

fn read_uint40(ref uint40_t v) {
	u64 value = v[0];
	value |= v[1] << 8;
	value |= v[2] << 16;
	value |= v[3] << 24;
	value |= v[4] << 32;
	return value;
};

fn read_int40(ref int40_t v) {
	u64 value = read_uint40(v);
	if (value & (1 << 39)) {
		return s64(value) - (1 << 40);
	}
	return value;
};

fn read_uint58(ref uint58_t v) {
	u64 value = v[0];
	value |= v[1] << 8;
	value |= v[2] << 16;
	value |= v[3] << 24;
	value |= v[4] << 32;
	value |= v[5] << 40;
	value |= v[6] << 48;
	return value;
};

fn read_int58(ref int58_t v) {
	u64 value = read_uint58(v);
	if (value & (1 << 57)) {
		return s64(value) - (1 << 58);
	}
	return value;
};
