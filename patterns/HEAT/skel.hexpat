// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description HEAT Skeleton

import std.sys;

#include "HEAT.hexpat"

struct SkeletonVersion {
	u32 version;
	Skeleton skeleton [[inline]];
};

SkeletonVersion skel @ 0;
