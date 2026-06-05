// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description Audiokinetic Audio Pack
#pragma magic [ 41 4B 50 4B ] @ 0x00
#pragma array_limit 0x1fffffff
#pragma pattern_limit 0x1fffffff

#include "Neptuwunium.hexpat"

struct AKPKHeader {
	u32 magic;
	u32 size;
	u32 version;
	u32 name_table_size;
	u32 bank_table_size;
	u32 stream_table_size;
	u32 external_table_size;
};

struct AKPKName<T> {
	u32 offset;
	u32 id;

	T name @ parent.start + offset;
};

struct AKPKArray<T> {
	u64 start = $;
	u32 count;
	T values[count];
};

struct AKPKEntry<T> {
	T id;
	u32 alignment;
	u32 size;
	u32 offset;
	u32 language_id;

	u8 buffer[size] @ offset;
};

struct _DetectWide {
	u8 value = $ + parent.header.name_table_size - 2;
	bool ok = value > 0;
};

struct AKPK {
	AKPKHeader header;

	_DetectWide is_wide [[no_unique_address, hidden]];

	if (is_wide.ok) {
		AKPKArray<AKPKName<CString16>> names [[fixed_size(header.name_table_size)]];
	} else {
		AKPKArray<AKPKName<CString8>> names [[fixed_size(header.name_table_size)]];
	}

	AKPKArray<AKPKEntry<u32>> banks;
	AKPKArray<AKPKEntry<u32>> streams;
	AKPKArray<AKPKEntry<u64>> external;
};

AKPK akpk @ 0;
