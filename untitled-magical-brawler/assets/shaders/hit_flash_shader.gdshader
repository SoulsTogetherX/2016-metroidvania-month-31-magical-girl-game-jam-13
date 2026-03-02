shader_type canvas_item;

uniform bool white_out = false;

void fragment() {
	if (white_out) {
    	vec4 texture_color = texture(TEXTURE, UV);
		COLOR = vec4(1.0, 1.0, 1.0, texture_color.a);
	}
}