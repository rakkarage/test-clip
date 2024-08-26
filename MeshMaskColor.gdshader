shader_type spatial;

uniform vec4 color: source_color = vec4(1, 1, 1, 1);
uniform vec2 mesh_mask_position = vec2(0, 0);
uniform vec2 mesh_mask_size = vec2(1, 1);

void fragment() {
	vec4 world_pos = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	vec2 frag_to_mask = (world_pos.xy - mesh_mask_position) / -VERTEX.z;
	if (any(greaterThan(abs(frag_to_mask), mesh_mask_size * 0.5))) {
		discard;
	}
	ALBEDO = color.rgb;
	ALPHA = color.a;
}
