import std.string;

struct Vector4D {
	float x, y, z, w;
} [[format("format_vector4d")]];

fn format_vector4d(ref Vector4D vec) {
	return std::format("{{ {}, {}, {}, {} }}", vec.x, vec.y, vec.z, vec.w);
}

struct Vector3D {
	float x, y, z;
} [[format("format_vector3d")]];

fn format_vector3d(ref Vector3D vec) {
	return std::format("{{ {}, {}, {} }}", vec.x, vec.y, vec.z);
}

struct Vector2D {
	float x, y;
} [[format("format_vector2d")]];

fn format_vector2d(ref Vector2D vec) {
	return std::format("{{ {}, {} }}", vec.x, vec.y);
}

struct Vector2H {
	ushort x, y;
} [[format("format_vector2h")]];

fn format_vector2h(ref Vector2H vec) {
	return std::format("{{ {}, {} }}", vec.x, vec.y);
}

struct Matrix4x4 {
	Vector4D m1, m2, m3, m4;
};

struct AABB {
	Vector3D min, max;
}
