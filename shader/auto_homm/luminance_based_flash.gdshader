shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float strength : hint_range(0.0, 1.0) = 0.0;
uniform float brightness_bias : hint_range(0.0, 2.0) = 1.2;

void fragment() {
	vec4 base = texture(TEXTURE, UV);

	float luminance = dot(base.rgb, vec3(0.299, 0.587, 0.114));
	float mask = pow(luminance, brightness_bias);

	vec3 flashed = mix(base.rgb, flash_color.rgb, strength * mask);

	COLOR = vec4(flashed, base.a);
}