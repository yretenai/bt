// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine Pack Info
#pragma endian big

struct ACEPackInfo {
	u8 type_ids[0xf];
	u32 object_flags;
	u32 render_flags;
	float mass;
	float debris_mass;
	float clip_bias;
	u16 lod_range[8];
};

ACEPackInfo pack @ 0;
