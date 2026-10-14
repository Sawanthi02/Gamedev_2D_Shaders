shader_type canvas_item;
uniform vec4 outline_color : source_color = vec4(1.0);
uniform float frequency = 20.0;
uniform float line_thickness : hint_range(0, 10) = 8.0;

float draw_effect(vec2 uv) {
	// zet de 0,0 punt van de UV in het midden ip links boven
	vec2 pixel_tot_center = uv - vec2(0.5);
	// default waarde dat de pixel te zien is
	float visible = 1.0;
	//bereken de hoek van de pixel tot het middenpunt 0,0
	float angle = atan(pixel_tot_center.y, pixel_tot_center.x);
	//sin functie dat de waarde van de hoek omzet in een wave waarde tussen 0 en 1??
	float wave = 0.5 * sin(frequency * angle) + 0.5;
	//als de wave waarde hoger is dan 0.5 blijft visible op true, anders false. zo hebben al pixels met de zelfde hoek tot het middenpunt een gelijke waarde voor visible
	visible *= step(0.5, wave);

	return visible;
}

void fragment() {
	//outline zoals in de les behandeld
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
	float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
	outline = min(outline, 1.0);


	outline *= draw_effect(UV);

	float texture_alpha = texture(TEXTURE, UV).a;
	vec4 texture_color = texture(TEXTURE, UV);

	COLOR = mix(vec4(0), outline_color, outline);
	COLOR = mix(COLOR, texture_color, texture_alpha);

}

//https://godotshaders.com/shader/dotted-circle/