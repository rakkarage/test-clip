shader_type spatial;

uniform sampler2D texture: source_color;

void fragment() {
	vec4 tex_color = texture(texture, UV);
	ALBEDO = tex_color.rgb;
	ALPHA = tex_color.a;
}
