shader_type canvas_item;

uniform float wall_thickness: hint_range(0.1, 10.0, 0.1) = 2.0;
uniform float total_cell_size: hint_range(0.1, 50.0, 0.1) = 20.0;

float draw_grid(vec2 uv) {
	//zet globale pixel pozitie om in de pozitie binnen een cel
	float pos_in_grid_x = mod(uv.x, total_cell_size);
	float pos_in_grid_y = mod(uv.y, total_cell_size);
    
	//kijk of de pixel deel is van de uiterste linker- of onderkant van de cel
    float grid_line_x = step(total_cell_size - wall_thickness, pos_in_grid_x); 
    float grid_line_y = step(total_cell_size - wall_thickness, pos_in_grid_y);
    
	//als pixel deel is van de linker of onderkant, return 1.0 anders 0.0
    return max(grid_line_x, grid_line_y);
}

void fragment() {
	float grid_visibility = draw_grid(UV * 100.0);
	float texture_alpha = texture(TEXTURE, UV).a;
	vec3 texture_color = texture(TEXTURE, UV).rgb;
	
	//zet kleur en maak alleen visible als het deel is van de texture en de grid met de min functie
    COLOR = vec4(texture_color, min(grid_visibility, texture_alpha)); 
}

//https://www.youtube.com/watch?v=peQaxcQ89SA&t=1092s&ab_channel=FencerDevLog