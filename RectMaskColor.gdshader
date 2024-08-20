shader_type spatial;

uniform vec4 color: source_color = vec4(1, 1, 1, 1);
uniform vec2 parent_position = vec2(0, 0);
uniform vec2 parent_size = vec2(1, 1);

void fragment() {
	vec2 frag_to_parent_xy = VERTEX.xy - parent_position.xy;
	vec2 abs_distance_xy = abs(frag_to_parent_xy);
	if (any(greaterThan(abs_distance_xy, parent_size.xy * 0.5))) {
		discard;
	}

	ALBEDO = color.rgb;
	ALPHA = color.a;
}
