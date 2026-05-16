// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine 2D UI Image
#pragma magic [ 55 49 32 44 ] @ 0x00
#pragma endian big

#include "Flight.hexpat"
#include "NeptuwuniumMath.hexpat"

enum UI2DLayerType : u32 {
	None = 0,
	Texture = 1,
	Transition = 2,
	Properties = 3,
	Shape = 4,
};

struct UI2DTexture {
	s32 count;
	u32 uitx_fhm_index;
	u32 texture_index;
	Vector4<u16> xywh;
	Vector4F rect;
	Vector2F scale;
	u32 reserved1 [[hidden]];
	u32 reserved2 [[hidden]];
};

struct UI2DLayer {
	UI2DLayerType type;

	if (type == UI2DLayerType::Texture) {
		UI2DTexture texture;
	}
};

struct UI2DLayerInfo {
	HashId layer_id;
	u32 offset;
	u32 size;

	UI2DLayer layer @ offset;
};

struct UI2D {
	u32 magic;
	HashId image_id;
	u32 layer_count;
	UI2DLayerInfo layers[layer_count];
};

UI2D ui @ 0;
