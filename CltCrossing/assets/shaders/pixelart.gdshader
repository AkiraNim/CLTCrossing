shader_type spatial;

const int pixel_size = 3;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float x = float(int(FRAGCOORD.x) % pixel_size);
	float y = float(int(FRAGCOORD.y) % pixel_size);

	x = FRAGCOORD.x + floor(float(pixel_size) / 2.0 ) - x;
	y = FRAGCOORD.y + floor(float(pixel_size) / 2.0 ) - y;

	ALBEDO = texture(SCREEN_TEXTURE, vec2(x,y) / VIEWPORT_SIZE).xyz;

}
