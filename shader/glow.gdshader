shader_type canvas_item;

uniform float glow_strength = 1.2;
uniform float pulse_speed = 2.0;
uniform vec4 glow_color : source_color = vec4(1.0, 0.9, 0.5, 1.0);

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5;
    COLOR = glow_color * tex.a * pulse * glow_strength;
}