// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

struct NovodexHeader {
	u8 magic[3];
	bool little;
	u8 chunk_id[4];
	u32 version;
};
