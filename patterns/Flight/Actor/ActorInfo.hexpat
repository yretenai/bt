// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description ACI Actor Info
#pragma endian big

struct ACEActor {
	u8 object_id;
	u8 id;
	u8 reserved[0xe];
};

struct ACEActorInfo {
	u8 count;
	u8 reserved[3];
	u16 type;
	u16 flags;
	u8 reserved2[8];

	ACEActor actors[count];
};

ACEPackInfo pack @ 0;
