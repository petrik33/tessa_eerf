shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(0.4, 0.8, 1.0, 1.0);
uniform float glow_size = 2.0;
uniform float glow_strength = 0.0;

void fragment() {
    vec4 base_color = texture(TEXTURE, UV);
    float alpha = base_color.a;

    float glow = 0.0;

    for (float x = -glow_size; x <= glow_size; x++) {
        for (float y = -glow_size; y <= glow_size; y++) {
            vec2 offset = vec2(x, y) * TEXTURE_PIXEL_SIZE;
            glow = max(glow, texture(TEXTURE, UV + offset).a);
        }
    }

    float outline = clamp(glow - alpha, 0.0, 1.0);
    vec4 final_color = base_color + glow_color * outline * glow_strength;

    COLOR = final_color;
}
