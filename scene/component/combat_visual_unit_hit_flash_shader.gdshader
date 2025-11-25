shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float flash_factor : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 original = texture(TEXTURE, UV);
    vec3 final_color = mix(original.rgb, flash_color.rgb, flash_factor);
    COLOR = vec4(final_color, original.a);
}
