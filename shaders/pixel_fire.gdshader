shader_type canvas_item;

uniform sampler2D noise_texture : repeat_enable;
uniform sampler2D gradient_texture;

uniform vec3 color_high : source_color = vec3(1,1,1);
uniform vec3 color_mid : source_color = vec3(1,1,1);
uniform vec3 color_low : source_color = vec3(1,1,1);

uniform float spread : hint_range(0.0, 1.0, 0.05) = 0.5;
uniform int pixel_size : hint_range(0, 100, 1) = 1;

vec4 fire(vec2 uv){
	vec2 uv2 = uv + vec2(0.0, TIME * 0.3);
	float noise = texture(noise_texture, uv2).r;
	float gradient = texture(gradient_texture, uv.yx).r;
	gradient -= smoothstep(spread, spread + 0.5, length(uv - vec2(0.5, 0.5)) / spread);

	float step1 = step(noise, gradient);
	float step2 = step(noise, gradient - 0.2);
	float step3 = step(noise, gradient - 0.4);

	vec3 hlcolor = mix(color_high, color_low, step1 - step2);
	vec4 color = vec4(hlcolor, step1);
	color.rgb = mix(color.rgb, color_mid, step2 - step3);

	return color;
}

vec4 pixel_fire(vec2 uv, vec2 tps){
	vec2 pos = uv / tps;
	vec2 square = vec2(float(pixel_size), float(pixel_size));
	vec2 tl = floor(pos / square) * square;
	vec4 color = vec4(0,0,0,0);
	for (int x = int(tl.x); x < int(tl.x) + pixel_size; x++){
		for (int y = int(tl.y); y < int(tl.y) + pixel_size; y++){
			color += fire(vec2(float(x), float(y)) * tps);
		}
	}
	return color / float(pixel_size * pixel_size);
}

void fragment() {
	//pixel_fire(UV, TEXTURE_PIXEL_SIZE);
	COLOR = pixel_fire(UV, TEXTURE_PIXEL_SIZE);
}