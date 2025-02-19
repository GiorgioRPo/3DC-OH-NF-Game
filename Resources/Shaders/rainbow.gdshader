shader_type canvas_item;

uniform int no_col = 3;
uniform vec3 color_1 = vec3(0.0,0.0,1.0);
uniform vec3 color_2 = vec3(0.0,1.0,0.0);
uniform vec3 color_3 = vec3(1.0,0.0,0.0);
uniform vec3 color_4 = vec3(1.0,1.0,1.0);

void fragment(){
	int number_of_cols = clamp(no_col,1,4);
	float lent = UV.x+UV.y;
	float size = 2.0;
	float time = 45.0;
	float tatime = 2.0;
	if(number_of_cols == 2){
		size = 1.6;
		time = 45.0;
		tatime = 2.0;
	}
	if(number_of_cols == 3){
		size = 1.0;
		time = 30.0;
		tatime = 2.0;
	}
	if(number_of_cols == 4){
		size = 0.8;
		time = 22.5;
		tatime = 1.5;
	}
	
//	float time_1 = sin(TIME)/0.9+ 1.0;
//	float time_2 = sin(TIME+ time)/0.9+ 1.0;
//	float time_3 = sin(TIME+ 3.0)/0.9+ 1.0;
	
	float time_1 = float(int(TIME*30.0) % 90)/18.0-1.2;
	float time_2 = float(int(TIME*30.0 + time) % 90)/18.0-1.2;
	float time_3 = float(int(TIME*30.0 + time*2.0) % 90)/18.0-1.2;
	float time_4 = float(int(TIME*30.0 + time*3.0) % 90)/18.0-1.2;
	
	float time_1b = float(int(TIME*30.0 - time*1.5) % 90)/18.0-1.2;
	float time_2b = float(int(TIME*30.0 - time/2.0) % 90)/18.0-1.2;
	float time_3b = float(int(TIME*30.0 - time*2.5) % 90)/18.0-1.2;
	float time_4b = float(int(TIME*30.0 - time*3.5) % 90)/18.0-1.2;
	
	
	float mask_1 = smoothstep(time_1-size+0.1,time_1-0.1,lent)
			* 1.0 - smoothstep(time_1,time_1+size,lent);
	float mask_2 = smoothstep(time_2-size+0.1,time_2-0.1,lent)
			* 1.0 - smoothstep(time_2,time_2+size,lent);
	float mask_3 = smoothstep(time_3-size+0.1,time_3-0.1,lent)
			* 1.0 - smoothstep(time_3,time_3+size,lent);
	float mask_4 = smoothstep(time_4-size+0.1,time_4-0.1,lent)
			* 1.0 - smoothstep(time_4,time_4+size,lent);
	
	float mask_1b = smoothstep(time_1b-size+0.1,time_1b-0.1,lent)
			* 1.0 - smoothstep(time_1b,time_1b+size,lent);
	float mask_2b = smoothstep(time_2b-size+0.1,time_2b-0.1,lent)
			* 1.0 - smoothstep(time_2b,time_2b+size,lent);
	float mask_3b = smoothstep(time_3b-size+0.1,time_3b-0.1,lent)
			* 1.0 - smoothstep(time_3b,time_3b+size,lent);
	float mask_4b = smoothstep(time_4b-size+0.1,time_4b-0.1,lent)
			* 1.0 - smoothstep(time_4b,time_4b+size,lent);
	
	COLOR = texture(TEXTURE,UV);
	
	if(number_of_cols == 1){
		COLOR.rgb += color_1;
	}
	if(number_of_cols == 2){
	COLOR += vec4(color_1 * mask_1,0.0);
	//COLOR = vec4(color_1 * mask_1,1.0);
	COLOR += vec4(color_2 * mask_2b,0.0);
	COLOR += vec4(color_1 * mask_2,0.0);
	COLOR += vec4(color_2 * mask_1b,0.0);
	}
	if(number_of_cols == 3){
	COLOR += vec4(color_1 * mask_1,0.0);
	//COLOR = vec4(color_1 * mask_1,1.0);
	COLOR += vec4(color_2 * mask_2,0.0);
	COLOR += vec4(color_3 * mask_3, 0.0);
	COLOR += vec4(color_1 * mask_1b,0.0);
	COLOR += vec4(color_2 * mask_2b,0.0);
	COLOR += vec4(color_3 * mask_3b, 0.0);
	}
	if(number_of_cols == 4){
	COLOR += vec4(color_1 * mask_1,0.0);
	//COLOR = vec4(color_1 * mask_1,1.0);
	COLOR += vec4(color_3 * mask_2,0.0);
	COLOR += vec4(color_1 * mask_3, 0.0);
	COLOR += vec4(color_3 * mask_4, 0.0);
	COLOR += vec4(color_4 * mask_1b,0.0);
	COLOR += vec4(color_2 * mask_2b,0.0);
	COLOR += vec4(color_2 * mask_3b, 0.0);
	COLOR += vec4(color_4 * mask_4b, 0.0);
	}
}