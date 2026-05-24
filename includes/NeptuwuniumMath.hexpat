// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma once
#pragma author Neptuwunium
#pragma description Neptuwunium Math Types

import std.string;

#include "NeptuwuniumInt.hexpat"

struct Vector4<Type> {
	Type x, y, z, w;
} [[format("format_vector4")]];

fn format_vector4(ref auto vec) {
	return std::format("{{ {}, {}, {}, {} }}", vec.x, vec.y, vec.z, vec.w);
};

using Vector4H = Vector4<half>;
using Vector4F = Vector4<float>;
using Vector4D = Vector4<double>;
using Color32 = Vector4<u8>;

struct Vector3<Type> {
	Type x, y, z;
} [[format("format_vector3")]];

fn format_vector3(ref auto vec) {
	return std::format("{{ {}, {}, {} }}", vec.x, vec.y, vec.z);
};

using Vector3H = Vector3<half>;
using Vector3F = Vector3<float>;
using Vector3D = Vector3<double>;

struct Vector2<Type> {
	Type x, y;
} [[format("format_vector2")]];

fn format_vector2(ref auto vec) {
	return std::format("{{ {}, {} }}", vec.x, vec.y);
};

using Vector2H = Vector2<half>;
using Vector2F = Vector2<float>;
using Vector2D = Vector2<double>;

struct Matrix4x4<Type> {
	Vector4<Type> m1, m2, m3, m4;
};

using Matrix4x4H = Matrix4x4<half>;
using Matrix4x4F = Matrix4x4<float>;
using Matrix4x4D = Matrix4x4<double>;

struct AABB<Type> {
	Vector3<Type> min, max;
};

using AABBH = AABB<half>;
using AABBF = AABB<float>;
using AABBD = AABB<double>;

struct CString<TChar> {
	TChar data[];
} [[format("format_string")]];

using CString8 = CString<char>;
using CString16 = CString<char16>;

struct CFixString<auto Size, TChar> {
	TChar data[Size];
} [[format("format_string")]];

using CFixString8<auto Size> = CFixString<Size, char>;
using CFixString16<auto Size> = CFixString<Size, char16>;

struct PString<TLen, TChar> {
	TLen length;
	TChar data[length];
} [[format("format_string")]];

using PString8 = PString<u8, char>;
using PString16 = PString<u16, char>;
using PString32 = PString<u32, char>;
using PString64 = PString<u64, char>;

fn format_string(ref auto pstr) {
	return std::format("{}", pstr.data);
};
