# SPDX-FileCopyrightText: 2026 Neptuwunium
#
# SPDX-License-Identifier: EUPL-1.2


import struct


def _mul(x: list[int], m: int, digit: int):
	if digit - 1 < 0: return

	carry = 0
	for i in range(digit - 1, -1, -1):
		result = (x[i] * m) + carry
		x[i] = result & 0xFFFFFFFF
		carry = result >> 32


def _div(x: list[int], d: int, digit: int):
	if digit <= 0: return

	remainder = 0
	for i in range(digit):
		current = (remainder << 32) + x[i]
		x[i] = current // d
		remainder = current % d


def _add(x: list[int], y: list[int], digit: int):
	if digit <= 0: return

	carry = 0
	for i in range(digit - 1, -1, -1):
		total = x[i] + y[i] + carry
		x[i] = total & 0xFFFFFFFF
		carry = total >> 32


def _sub(x: list[int], y: list[int], digit: int):
	if digit <= 0: return

	borrow = 0
	for i in range(digit - 1, -1, -1):
		diff = x[i] - y[i] - borrow
		if diff < 0:
			diff += 0x100000000
			borrow = 1
		else:
			borrow = 0
		x[i] = diff & 0xFFFFFFFF


def _arctangent(x: list[int], r: int, m: int, digit: int):
	y = [0] * 0x20D
	y[0] = m

	_div(y, r, digit)
	for i in range(digit): x[i] = y[i]

	r_squared = r * r
	divisor = 3
	sign = 1

	while True:
		_div(y, r_squared, digit)

		temp = y[:digit]
		_div(temp, divisor, digit)

		if all(val == 0 for val in temp): break

		if (sign & 1) != 0: _sub(x, temp, digit)
		else: _add(x, temp, digit)

		divisor += 2
		sign += 1


def _create_table(seed: int) -> list[int]:
	x = [0] * 0x209
	y = [0] * 0x20D
	z = ((seed << 4) + 0x28) >> 3
	# https://en.wikipedia.org/wiki/Machin-like_formula up to 515 bytes
	_arctangent(x, 5, 4, z)
	_arctangent(y, 239, 1, z)
	_sub(x, y, z)
	_mul(x, 4, z)
	return x


def _create_xor(seed: int) -> bytearray:
	global PI
	seed_shr4 = (seed & 0xFF) << 4

	# this calculates it up to the appropriate digit count, but we can just precalc it to 515.

	# digit = (seed_shr4 + 0x28) >> 3
	# x = [0] * 0x209
	# y = [0] * 0x20D

	# _arctangent(x, 5, 4, digit)
	# _arctangent(y, 239, 1, digit)
	# _sub(x, y, digit)
	# _mul(x, 4, digit)

	index = (seed_shr4 + 0x10) >> 3
	# load two ints
	return bytearray(struct.pack('>II', PI[index] & 0xFFFFFFFF, PI[index + 1] & 0xFFFFFFFF))


def decrypt(seed: int, data: bytearray, start_idx: int = 0):
	xor = _create_xor(seed)
	for i in len(data):
		data[i] ^= xor[start_idx % 8]
		start_idx += 1


PI = _create_table(0xff)

if __name__ == '__main__':
	with open('xor_table.bin', 'wb') as table:
		for seed in range(0x100):
			xor = _create_xor(seed)
			print(xor.hex())
			table.write(xor)
