shader_type canvas_item;

uniform float distance_threshold;
uniform float intensity;

void fragment()
{
	vec2 diff = SCREEN_UV - vec2(0.5f, 0.5f);
	float distance = sqrt(diff.x * diff.x + diff.y * diff.y);
	vec4 bg = texture(SCREEN_TEXTURE, SCREEN_UV);
	float avg = (bg.r + bg.g + bg.b) / 3f;
	if (distance < distance_threshold) {
		COLOR = bg;
	} else {
		float factor = distance - distance_threshold;
		COLOR = vec4(bg.r * (1f + factor * factor * intensity * 10f), bg.g, bg.b, 1f);
	}
}

