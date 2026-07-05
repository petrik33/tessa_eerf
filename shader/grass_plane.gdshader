	shader_type spatial;

	uniform vec4 albedo : source_color;
	uniform sampler2D albedo_noise : source_color;
	uniform float albedo_noise_scale = 1.0;
	uniform float albedo2_threshold : hint_range(0.0, 1.0) = 0.5f;
	uniform vec4 albedo2 : source_color = vec4(1.0f);
	uniform sampler2D albedo2_noise : source_color;
	uniform float albedo3_threshold : hint_range(0.0, 1.0) = 0.5f;
	uniform vec4 albedo3 : source_color = vec4(1.0f);

	uniform sampler2D wind_noise : source_color;
	uniform float wind_noise_scale = 1.0f;
	uniform float sway_angle = 30.0f;
	uniform vec2 wind_direction;

	uniform sampler2D terrain_texture : source_color, filter_nearest, repeat_enable;
	uniform vec2 terrain_center = vec2(0.0f, 0.0f);
	uniform vec2 terrain_size = vec2(4.0f, 1.0f);
	uniform vec3 terrain_border_glow = vec3(1.0, 1.0, 1.0);
	uniform float terrain_border_glow_strength = 1.0;


	varying vec3 object_origin;


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

	float terrainMask() {
		vec2 terrain_uv = (object_origin.xz - terrain_center) / terrain_size + vec2(0.5);

		float terrain_mask =
		    step(0.0, terrain_uv.x) *
		    step(terrain_uv.x, 1.0) *
		    step(0.0, terrain_uv.y) *
		    step(terrain_uv.y, 1.0);
		
		terrain_mask *= texture(terrain_texture, terrain_uv).r;
		
		return terrain_mask;
	}


	void vertex() {
		object_origin = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	}


	void fragment() {
		ALBEDO = colorPatching();
		
		// PBR
		METALLIC = 0.0;
		SPECULAR = 0.0;
		ROUGHNESS = 0.0;
	}


	void light() {
		float light_value = clamp(dot(NORMAL, LIGHT), 0.0, 1.0);
		DIFFUSE_LIGHT += light_value * (LIGHT_COLOR / PI) * ATTENUATION;
	}
