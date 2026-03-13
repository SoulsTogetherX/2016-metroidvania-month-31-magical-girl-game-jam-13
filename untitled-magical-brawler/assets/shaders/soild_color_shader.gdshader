shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float precentage : hint_range(0.0, 1.0, 0.01) = 0.0;

void fragment() {
	COLOR = vec4(
		mix(COLOR.rgb, color.rgb, precentage),
		COLOR.a
	);
}