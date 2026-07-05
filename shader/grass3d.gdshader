shader_type spatial;


uniform vec4 albedo : source_color = vec4(1.0f);
uniform sampler2D albedo_texture : source_color, filter_nearest, repeat_enable;
uniform sampler2D albedo_noise : source_color;
uniform float albedo_noise_scale = 1.0f;
uniform float albedo2_threshold : hint_range(0.0, 1.0) = 0.5f;
uniform vec4 albedo2 : source_color = vec4(1.0f);
uniform sampler2D albedo2_noise : source_color;
uniform float albedo3_threshold : hint_range(0.0, 1.0) = 0.5f;
uniform vec4 albedo3 : source_color = vec4(1.0f);

uniform float accent1_probability : hint_range(0.0, 1.0) = 0.1f;
uniform vec4 accent1_albedo : source_color = vec4(1.0f);
uniform sampler2D accent1_texture : source_color, filter_nearest, repeat_enable;
uniform float accent1_scale = 1.0f;
uniform float accent1_height = 0.0f;

uniform float accent2_probability : hint_range(0.0, 1.0) = 0.1f;
uniform vec4 accent2_albedo : source_color = vec4(1.0f);
uniform sampler2D accent2_texture : source_color, filter_nearest, repeat_enable;
uniform float accent2_scale = 1.0f;
uniform float accent2_height = 0.0f;

uniform sampler2D wind_noise : source_color;
uniform float wind_noise_scale = 1.0f;
uniform float sway_angle = 30.0f;
uniform vec2 wind_direction;


varying vec3 node_pos_view;
varying vec3 object_origin;

varying float accent1_value;
varying float accent2_value;


float random(float seed) {
    float golden_ratio_seed = seed * 1.61803398875;
    return fract(sin(golden_ratio_seed * 12.9898) * 43758.5453);
}

vec3 rotatePositionAroundAxis(vec3 pos, vec3 axis, float angle) {
    vec3 n = normalize(axis);
    float c = cos(angle);
    float s = sin(angle);
    
    // Rodrigues' rotation formula applied directly to position
    return pos * c + cross(n, pos) * s + n * dot(n, pos) * (1.0 - c);
}

vec3 colorPatching() {
	vec2 albedo_noise_uv = object_origin.xz * albedo_noise_scale;
	float albedo_noise_val = texture(albedo_noise, albedo_noise_uv).r;
	
	if (albedo_noise_val < albedo2_threshold) {
		return albedo.rgb;
	}
	
	float albedo2_noise_val = texture(albedo2_noise, albedo_noise_uv).r;
	float mask = step(albedo3_threshold, albedo2_noise_val);
	
	return mix(albedo2, albedo3, mask).rgb;
}

vec4 grassAlbedoAndAlpha(vec2 base_uv) {
	if (accent1_value < accent1_probability) {
		vec4 albedo_tex = texture(accent1_texture, base_uv);
		return vec4(accent1_albedo.rgb, albedo_tex.a);
	}
	
	if (accent2_value < accent2_probability) {
		vec4 albedo_tex = texture(accent2_texture, base_uv);
		return vec4(accent2_albedo.rgb, albedo_tex.a);
	}
		
	vec4 albedo_tex = texture(albedo_texture, base_uv);
	vec3 color_patch = colorPatching();
	return vec4(color_patch, albedo_tex.a);
}


void vertex() {
	// Accent Generation
	float instance_id = float(INSTANCE_ID);
	accent1_value = random(instance_id);
	accent2_value = random(instance_id + PI);
	
	if (accent1_value < accent1_probability) {
		VERTEX.y += accent1_height;
		VERTEX *= accent1_scale;
	} else if (accent2_value < accent2_probability) {
		VERTEX.y += accent2_height;
		VERTEX *= accent2_scale;
	}
	
	// Object Origin for color patching
	object_origin = MODEL_MATRIX[3].xyz;
	
	// Wind Animation
	vec2 wind_noise_uv = object_origin.xz * wind_noise_scale;
	float wind_noise_sample = texture(wind_noise, wind_noise_uv).r;
	float wind_world_sway = wind_noise_sample * radians(sway_angle);
	vec3 wind_axis = (vec4(wind_direction.y, 0.0, -wind_direction.x, 1.0) * INV_VIEW_MATRIX).xyz;
    VERTEX = rotatePositionAroundAxis(VERTEX, wind_axis, wind_world_sway);
	
	// Billboard Mode: Y-Billboard
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			vec4(normalize(cross(vec3(0.0, 1.0, 0.0), MAIN_CAM_INV_VIEW_MATRIX[2].xyz)), 0.0),
			vec4(0.0, 1.0, 0.0, 0.0),
			vec4(normalize(cross(MAIN_CAM_INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0),
			MODEL_MATRIX[3]);

	// Billboard Keep Scale: Enabled
	MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(
			vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0),
			vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0),
			vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0),
			vec4(0.0, 0.0, 0.0, 1.0));
	
	// Lighting fix
	node_pos_view = NODE_POSITION_VIEW;
}

void fragment() {
	vec2 base_uv = UV;
	
	// Albedo
	vec4 grass = grassAlbedoAndAlpha(base_uv);
	ALBEDO = grass.rgb;
	
	// Alpha scissoring
	ALPHA = grass.a;
	ALPHA_SCISSOR_THRESHOLD = 1.0;
	
	// PBR
	METALLIC = 0.0;
	ROUGHNESS = 0.0;
	SPECULAR = 0.0;
	
	// Lighting fix
	LIGHT_VERTEX = node_pos_view;
}


void light() {
	float light_value = clamp(dot(NORMAL, LIGHT), 0.0, 1.0);
	DIFFUSE_LIGHT += light_value * (LIGHT_COLOR / PI) * ATTENUATION;
}

