// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description World of Warships Moo Splash

#include "NeptuwuniumInt.hexpat"
#include "NeptuwuniumMath.hexpat"

struct SplashBox {
	PString32 name;
	AABBF bounds;
};

struct Splash {
	u32 count;
	SplashBox entries[count];
};

Splash file @ 0;
