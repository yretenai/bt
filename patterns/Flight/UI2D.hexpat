// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine 2D UI Image
#pragma magic [ 55 49 32 44 ] @ 0x00
#pragma endian big

#include "Flight.hexpat"

enum UI2DLayerType : uint32_t {
	None = 0,
	Texture = 1,
	Transition = 2,
	Properties = 3,
	Shape = 4,
};

struct UI2DTexture {
	int32_t count;
	uint32_t uitx_fhm_index;
	uint32_t texture_index;
	Vector4<uint16_t> xywh;
	Vec4F rect;
	Vec2 scale;
	uint32_t reserved1 [[hidden]];
	uint32_t reserved2 [[hidden]];
};

struct UI2DLayer {
	UI2DLayerType type;

	if (type == UI2DLayerType::Texture) {
		UI2DTexture texture;
	}
};

struct UI2DLayerInfo {
	HashId layer_id;
	uint32_t offset;
	uint32_t size;

	UI2DLayer layer @ offset;
};

struct UI2D {
	uint32_t magic;
	HashId image_id;
	uint32_t layer_count;
	UI2DLayerInfo layers[layer_count];
};

UI2D ui @ 0;
