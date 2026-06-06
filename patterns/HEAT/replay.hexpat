// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#pragma author Neptuwunium
#pragma description HEAT Replay
#pragma pattern_limit 0x1fffffff
#pragma array_limit 0x1fffffff

import std.sys;
import std.mem;

#include "HEAT.hexpat"

struct ReplayInt {
	u8 v0;
	u8 c = v0 & 3;

	if (c >= 1) {
		u8 v1;
	} else {
		u8 v1 = 0;
	}

	if (c >= 2) {
		u8 v2;
	} else {
		u8 v2 = 0;
	}

	if (c >= 3) {
		u8 v3;
	} else {
		u8 v3 = 0;
	}

	u32 v = v0 | (v1 << 8) | (v2 << 16) | (v3 << 24);
	u32 value = v >> 2 [[export]];
};

struct ReplayString {
	ReplayInt length;
	char text[length.value];
} [[format("format_replay_string")]];

fn format_replay_string(auto v) {
	return v.text;
};

bitfield ReplayDomain {
	Editor: 1;
	ClientUI: 1;
	ClientNoUI: 1;
	ServerUI: 1;
	ServerNoUI: 1;
} [[fixed_size(4)]];

struct ReplayHeader {
	ReplayString magic;
	ReplayString world;
	ReplayString version;
	ReplayDomain domain;
	u64 replication_hash;
	u64 input_hash;
	u64 message_bus_hash;
	u64 predefined_replicables_hash;
	u64 timestamp;
	ReplayString replication;
	ReplayString input;
	ReplayString message_bus;
	ReplayString predefined_replicables;
};

enum ReplayEventType : u8 {
	None,
	PlayerId1,
	PlayerId2,
	Payload1,
	Payload2,
	Payload3,
	LoadPrefab,
	Payload4,
	Payload5,
	InputEvent,
	CustomEvent,
};

using ReplayPlayerId = u8;

struct ReplayLoadPrefab {
	ReplayString prefab_path;
	u32 child_index;
	ReplayInt size;
	char data[size.value];
};

bool type_id_witness[0xff] = {0};

struct ReplayCustomEvent {
	u8 type_id;

	if (!type_id_witness[type_id]) {
		ReplayString type_name;
		type_id_witness[type_id] = true;
	}

	ReplayInt size;
	u8 data[size.value];
};

struct ReplayPayloadPacket {
	ReplayInt size;

	std::assert(size.value <= 0x4000, "packet too big");

	u8 data[size.value];
};

struct ReplayPayload {
	u64 payload_id;
	ReplayInt payload_count;
	ReplayPayloadPacket packets[payload_count.value];
};

struct ReplayInputEvent {
	ReplayInt size;
	u8 data[size.value];
};

struct ReplayEvent {
	ReplayEventType event_type;
	u32 frame_id;

	if (event_type == ReplayEventType::PlayerId1 || event_type == ReplayEventType::PlayerId2) {
		ReplayPlayerId player_id;
	} else if (event_type == ReplayEventType::Payload1 || event_type == ReplayEventType::Payload2 ||
		event_type == ReplayEventType::Payload3 || event_type == ReplayEventType::Payload4 || event_type == ReplayEventType::Payload5) {
		ReplayPayload packet_payload;
	} else if (event_type == ReplayEventType::LoadPrefab) {
		ReplayLoadPrefab load_prefab;
	} else if (event_type == ReplayEventType::InputEvent) {
		ReplayInputEvent input_event;
	} else if (event_type == ReplayEventType::CustomEvent) {
		ReplayCustomEvent custom_event;
	} else {
		std::assert(false, "unknown replay type");
	}
};

struct CR08 {
	ReplayHeader header;
	ReplayEvent events[while(!std::mem::eof())];
};

CR08 replay @ 0;
