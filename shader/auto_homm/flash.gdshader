shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float strength : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	vec3 flashed = mix(base.rgb, flash_color.rgb, strength);
	COLOR = vec4(flashed, base.a);
}