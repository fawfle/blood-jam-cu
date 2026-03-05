shader_type canvas_item;

uniform float taking_damage: hint_range(0.0, 1.0);
uniform vec3 damage_color = vec3(1.0, 1.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 color = mix(COLOR.rgb, damage_color, taking_damage);

	COLOR = vec4(color, COLOR.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
