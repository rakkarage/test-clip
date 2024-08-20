shader_type spatial;

uniform vec4 color: source_color = vec4(1, 1, 1, 1);
uniform vec2 mesh_mask_position = vec2(0, 0);
uniform vec2 mesh_mask_size = vec2(1, 1);

void fragment() {
	vec2 frag_to_parent_xy = VERTEX.xy - mesh_mask_position.xy;
	vec2 abs_distance_xy = abs(frag_to_parent_xy);
	if (any(greaterThan(abs_distance_xy, mesh_mask_size.xy * 0.5))) {
		discard;
	}

	ALBEDO = color.rgb;
	ALPHA = color.a;
}
