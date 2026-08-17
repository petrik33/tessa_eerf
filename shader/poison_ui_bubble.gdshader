shader_type canvas_item;

uniform vec4 base_color : source_color = vec4(0.49, 0.66, 0.20, 1.0);
uniform vec4 bubble_color : source_color = vec4(0.77, 0.90, 0.42, 1.0);

uniform float speed = 0.8;
uniform float bubble_scale = 7.0;
uniform float bubble_strength = 0.35;

uniform float flash_strength : hint_range(0.0, 1.0) = 0.0;


float hash(vec2 p)
{
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453);
}

float noise(vec2 p)
{
    vec2 i = floor(p);
    vec2 f = fract(p);

    float a = hash(i);
    float b = hash(i + vec2(1.0,0.0));
    float c = hash(i + vec2(0.0,1.0));
    float d = hash(i + vec2(1.0,1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x)
        + (c - a) * u.y * (1.0 - u.x)
        + (d - b) * u.x * u.y;
}


void fragment()
{
    vec2 uv = UV;

    float current_speed = mix(speed, speed * 3.0, flash_strength);
    float current_scale = mix(bubble_scale, bubble_scale * 1.35, flash_strength);
    float current_strength = mix(bubble_strength, bubble_strength * 1.3, flash_strength);

    uv.x += TIME * current_speed;

    float n = noise(uv * current_scale);

    float mask = smoothstep(
        0.55 - current_strength,
        0.55 + current_strength,
        n
    );

    vec4 col = mix(base_color, bubble_color, mask);
    col.rgb *= 1.0 + flash_strength * 0.35;

    COLOR = col;
}