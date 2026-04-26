# SPDX-FileCopyrightText: 2026 Neptuwunium
#
# SPDX-License-Identifier: EUPL-1.2


import struct
import numpy


class CollisionFace:
	def __init__(self, f, version):
		count = struct.unpack('<I', f.read(4))[0]
		self.inner = struct.unpack('<%dI' % (count), f.read(count * 4))
		self.outer = struct.unpack('<%dI' % (count), f.read(count * 4))
		self.flag = struct.unpack('<I', f.read(4))[0] if version != 0x26092011 else 0


class CollisionHull:
	def __init__(self, f, version):
		vertex_count = struct.unpack('<I', f.read(4))[0]
		vertices = struct.unpack('<%df' % (vertex_count * 3), f.read(vertex_count * 12))
		self.vertices = [tuple(vertices[i:i+3]) for i in range(0, vertex_count * 3, 3)]
		edge_count = struct.unpack('<I', f.read(4))[0]
		edges = struct.unpack('<%dI' % (edge_count * 2), f.read(edge_count * 8))
		self.edges = [tuple(edges[i:i+2]) for i in range(0, edge_count * 2, 2)]
		face_count = struct.unpack('<I', f.read(4))[0]
		self.faces = [CollisionFace(f, version) for i in range(0, face_count)]


class Collision:
	def __init__(self, f):
		(version, count) = struct.unpack('<Ii', f.read(8))
		self.hulls = [CollisionHull(f, version) for i in range(0, count)]


coll = None
with open('collision.bin', 'rb') as f:
	f.seek(0x20)
	coll = Collision(f)

print("o Collision")
for idx in range(len(coll.hulls)):
	hull = coll.hulls[idx]
	for vert in hull.vertices:
		print("v %f %f %f" % (vert[0], vert[1], vert[2]))
base = 1
for idx in range(len(coll.hulls)):
	hull = coll.hulls[idx]
	# for edge in hull.edges:
	# 	print("l %d %d" % (edge[0] + base, edge[1] + base))
	for face in hull.faces:
		edges = [hull.edges[edge] for edge in face.outer]
		edge_order = [edges[0][0]]
		current = edge_order[0]
		while len(edge_order) < len(face.outer):
			for e in edges:
				if current in e:
					next = e[1] if e[0] == current else e[0]
					if next not in edge_order:
						edge_order.append(next)
						current = next
						break
			else:
				raise Exception("not contigious")
		print(("f " + "%d " * len(face.outer)) % tuple([v + base for v in edge_order]))
	base = base + len(hull.vertices)

