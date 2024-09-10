shader_type spatial;

uniform vec4 color: source_color = vec4(1, 1, 1, 1);
uniform vec3 mask_position = vec3(0, 0, 0);
uniform vec2 mask_size = vec2(1, 1);

void fragment() {
	// Transform mask corners to clip space
	vec4 mask_center = PROJECTION_MATRIX * VIEW_MATRIX * vec4(mask_position, 1.0);
	vec4 mask_extent = PROJECTION_MATRIX * VIEW_MATRIX * vec4(mask_size.x * 0.5, mask_size.y * 0.5, 0.0, 0.0);

	// Calculate mask bounds in clip space
	vec2 mask_min = mask_center.xy / mask_center.w - abs(mask_extent.xy / mask_center.w);
	vec2 mask_max = mask_center.xy / mask_center.w + abs(mask_extent.xy / mask_center.w);

	// Current fragment position in clip space
	vec2 clip_pos = SCREEN_UV * 2.0 - 1.0;

	// Check if the current fragment is within the mask boundaries
	if (clip_pos.x < mask_min.x || clip_pos.x > mask_max.x || clip_pos.y < mask_min.y || clip_pos.y > mask_max.y) {
		discard;
	}

	ALBEDO = color.rgb;
	ALPHA = color.a;
}
