shader_type spatial;

uniform sampler2D viewport_texture : source_color;
uniform vec2 parent_position;
uniform vec2 parent_size;

void fragment() {
	vec2 frag_to_parent_xy = VERTEX.xy - parent_position.xy;
	vec2 abs_distance_xy = abs(frag_to_parent_xy);
	if (any(greaterThan(abs_distance_xy, parent_size.xy * 0.5))) {
		discard;
	}

	vec4 ui_color = texture(viewport_texture, UV);
	ALBEDO = ui_color.rgb;
	ALPHA = ui_color.a;
}
