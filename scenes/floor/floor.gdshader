shader_type canvas_item;

uniform vec3 blood_color = vec3(1.0, 0.0, 0.0);
uniform sampler2D blood;

void fragment() {
	vec3 color = texture(TEXTURE, UV).rgb;
	float covered = texture(blood, UV).a;
	color = mix(color, blood_color, covered);
	COLOR = vec4(color, 1.0);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
