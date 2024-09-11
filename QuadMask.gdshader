shader_type spatial;

uniform sampler2D texture: source_color;
uniform mat4 mask_transform = mat4(1.0);
uniform vec2 mask_size = vec2(1.0);

varying vec2 mask_min;
varying vec2 mask_max;

const int NUM_CORNERS = 4;

void vertex() {
	mat4 clip_space = PROJECTION_MATRIX * VIEW_MATRIX * mask_transform;
	vec2 half_size = mask_size * 0.5;
	vec4 corners[NUM_CORNERS] = {
		clip_space * vec4(-half_size.x, -half_size.y, 0.0, 1.0),
		clip_space * vec4(half_size.x, -half_size.y, 0.0, 1.0),
		clip_space * vec4(half_size.x, half_size.y, 0.0, 1.0),
		clip_space * vec4(-half_size.x, half_size.y, 0.0, 1.0)
	};
	mask_min = vec2(1.0);
	mask_max = vec2(-1.0);
	for (int i = 0; i < NUM_CORNERS; i++) {
		vec2 corner = corners[i].xy / corners[i].w;
		mask_min = min(mask_min, corner);
		mask_max = max(mask_max, corner);
	}
}

void fragment() {
	vec2 clip_pos = SCREEN_UV * 2.0 - 1.0;
	if (any(lessThan(clip_pos, mask_min)) || any(greaterThan(clip_pos, mask_max))) {
		discard;
	}
	vec4 tex_color = texture(texture, UV);
	ALBEDO = tex_color.rgb;
	ALPHA = tex_color.a;
}
