shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float negative : hint_range(0,1) = 1.0;
uniform float reverse : hint_range(0,1) = 0.0;
uniform float reverse_x : hint_range(0,1) = 0.0;

void fragment() {
    COLOR = textureLod(screen_texture, vec2(0.5 + (SCREEN_UV.x-0.5)*tan(reverse_x*PI/2.0+PI/4.0), 0.5 + (SCREEN_UV.y-0.5)*tan(reverse*PI/2.0+PI/4.0)), 0.0);
	COLOR.r = 0.5 + (0.5-COLOR.r)*(1.0-negative*2.0);
	COLOR.g = 0.5 + (0.5-COLOR.g)*(1.0-negative*2.0);
	COLOR.b = 0.5 + (0.5-COLOR.b)*(1.0-negative*2.0);
}