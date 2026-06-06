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
	PlayerConnected,
	PlayerDisconnceted,
	EditorPacket,
	ClientUIPacket,
	ClientNoUIPacket,
	Prefab,
	ServerUIPacket,
	ServerNoUIPacket,
	Input,
	Custom,
};

using ReplayPlayerEvent = u8;

struct ReplayPrefabEvent {
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

struct ReplayPacketPayload {
	ReplayInt size;

	std::assert(size.value <= 0x4000, "packet too big");

	u8 data[size.value];
};

struct ReplayPacketEvent {
	u64 packet_id;
	ReplayInt payload_count;
	ReplayPacketPayload packets[payload_count.value];
};

enum PacketInputType : u8 {
	None,
	Keyboard,
	MouseButton,
	MouseMove,
	MouseWheel,
	TextInput,
};

bitfield PacketKeyboardFlags {
	is_pressed: 1;
	is_repeat: 1;
	unknown: 6;
} [[fixed_size(1)]];

enum MouseButtonType : u8 {
	None,
	Left,
	Middle,
	Right,
};

bitfield PacketButtonInfo {
	MouseButtonType id: 7;
	is_down: 1;
} [[fixed_size(1)]];

struct PacketInputFloat {
	u16 raw_value;
	float value = float(raw_value) / float(0x8000) [[export]];
};

struct PacketInput {
	PacketInputType input_type;
	u16 modifier_keys;
	
	if(input_type == PacketInputType::Keyboard) {
		u16 key_id;
		u8 key_mod;
		PacketKeyboardFlags flags;
	} else if(input_type == PacketInputType::MouseButton) {
		Vector2<PacketInputFloat> pos;
		PacketButtonInfo button_id;
		u8 num_clicks;
	} else if(input_type == PacketInputType::MouseMove) {
		Vector2<PacketInputFloat> pos;
		Vector2<PacketInputFloat> delta;
	} else if(input_type == PacketInputType::MouseWheel) {
		Vector2<PacketInputFloat> delta;
	} else if(input_type == PacketInputType::TextInput) {
		u16 length;
		CFixString8<length> text;
	}
};

struct ReplayInputEvent {
	ReplayInt size;
	PacketInput data;
};

struct ReplayEvent {
	ReplayEventType event_type;
	u32 frame_id;

	if (event_type == ReplayEventType::PlayerConnected || event_type == ReplayEventType::PlayerDisconnceted) {
		ReplayPlayerEvent player_event;
	} else if (event_type == ReplayEventType::EditorPacket || 
		event_type == ReplayEventType::ClientUIPacket || event_type == ReplayEventType::ClientNoUIPacket ||
		event_type == ReplayEventType::ServerUIPacket || event_type == ReplayEventType::ServerNoUIPacket) {
		ReplayPacketEvent packet_event;
	} else if (event_type == ReplayEventType::Prefab) {
		ReplayPrefabEvent prefab_event;
	} else if (event_type == ReplayEventType::Input) {
		ReplayInputEvent input_event;
	} else if (event_type == ReplayEventType::Custom) {
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
