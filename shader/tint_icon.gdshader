shader_type canvas_item;

uniform vec4 accent_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);

float luminance(vec3 color) {
    return dot(color, vec3(0.299, 0.587, 0.114));
}

vec3 rgb_to_hsl(vec3 color) {
    float max_c = max(max(color.r, color.g), color.b);
    float min_c = min(min(color.r, color.g), color.b);
    float h = 0.0;
    float s = 0.0;
    float l = luminance(color);

    if (max_c != min_c) {
        float d = max_c - min_c;
        s = l > 0.5 ? d / (2.0 - max_c - min_c) : d / (max_c + min_c);
        if (max_c == color.r)
            h = (color.g - color.b) / d + (color.g < color.b ? 6.0 : 0.0);
        else if (max_c == color.g)
            h = (color.b - color.r) / d + 2.0;
        else
            h = (color.r - color.g) / d + 4.0;
        h /= 6.0;
    }

    return vec3(h, s, l);
}

float hue2rgb(float p, float q, float t) {
    if (t < 0.0) t += 1.0;
    if (t > 1.0) t -= 1.0;
    if (t < 1.0 / 6.0) return p + (q - p) * 6.0 * t;
    if (t < 1.0 / 2.0) return q;
    if (t < 2.0 / 3.0) return p + (q - p) * (2.0 / 3.0 - t) * 6.0;
    return p;
}

vec3 hsl_to_rgb(vec3 hsl) {
    float h = hsl.x;
    float s = hsl.y;
    float l = hsl.z;

    if (s == 0.0)
        return vec3(l);

    float q = l < 0.5 ? l * (1.0 + s) : l + s - l * s;
    float p = 2.0 * l - q;

    float r = hue2rgb(p, q, h + 1.0 / 3.0);
    float g = hue2rgb(p, q, h);
    float b = hue2rgb(p, q, h - 1.0 / 3.0);

    return vec3(r, g, b);
}

void fragment() {
    vec4 base = texture(TEXTURE, UV);

    vec3 base_hsl = rgb_to_hsl(base.rgb);
    vec3 accent_hsl = rgb_to_hsl(accent_color.rgb);

    // Color blend mode: use hue + saturation from accent, lightness from base
    vec3 mixed_hsl = vec3(accent_hsl.x, accent_hsl.y, base_hsl.z);
    vec3 mixed_rgb = hsl_to_rgb(mixed_hsl);

    COLOR = vec4(mixed_rgb, base.a);
}