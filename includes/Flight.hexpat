// SPDX-FileCopyrightText: 2026 Neptuwunium
//
// SPDX-License-Identifier: EUPL-1.2

#include "NeptuwuniumInt.hexpat"

using HashId = u32 [[format_read("format_hashid")]];

fn format_hashid(ref HashId id) {
	return std::format("[0x{:08x}]", id);
};
