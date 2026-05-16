// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Flight Engine Tips File
#pragma magic [ 54 50 53 00 ] @ 0x00
#pragma endian big

#include "Flight.hexpat"

struct Tip {
	HashId message_id;
	uint32_t category;
	uint32_t flags;
};

struct RandomTip {
	uint32_t id;
	HashId message_id[6];
	float chance;
	uint32_t direction;
};

struct TPS {
	uint32_t magic;
	uint32_t version;
	uint32_t tips_count[7];
	uint32_t random_tip_count;
	uint32_t reserved1 [[hidden]];
	uint32_t reserved2 [[hidden]];
	Tip category_1[tips_count[0]];
	Tip category_2[tips_count[1]];
	Tip category_3[tips_count[2]];
	Tip category_4[tips_count[3]];
	Tip category_5[tips_count[4]];
	Tip category_6[tips_count[5]];
	Tip category_7[tips_count[6]];
	RandomTip random_tips[random_tip_count];
};

TPS tps @ 0;
