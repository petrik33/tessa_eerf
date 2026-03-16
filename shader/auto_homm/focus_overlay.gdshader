shader_type canvas_item;

uniform vec2 focus_points[8];
uniform int focus_count = 0;

uniform float radius = 72.0;
uniform float softness = 18.0;

varying vec2 local_pos;

void vertex() {
	local_pos = VERTEX;
}

 
void fragment() { 
    vec2 pixel = local_pos; 
	float mask = 1.0;
	
    for (int i = 0; i < focus_count; i++) {
        float d = distance(pixel, focus_points[i]);
        float m = smoothstep(radius - softness, radius, d);
        mask = min(mask, m);
    }

    COLOR.a *= mask;
}