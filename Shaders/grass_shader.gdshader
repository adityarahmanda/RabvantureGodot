shader_type canvas_item;

uniform float speed : hint_range(0.0, 10.0) = 1.0;
uniform float minStrength : hint_range(0.0, 1.0);
uniform float maxStrength : hint_range(0.0, 1.0);
uniform float strengthScale = 100.0;
uniform float interval = 3.5;
uniform float detail = 1.0;
uniform float heightOffset = 0.0;
uniform float distortion : hint_range(0.0, 1.0);
uniform float skew: hint_range(0.0, 500.0) = 0;
uniform vec2 player_pos = vec2(0.0);
uniform float player_radius = 20.0;

varying vec2 world_pos;
varying float player_mask;
varying float grass_skew;

float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

float getWind(vec2 vertex, vec2 uv, float timer){
	vec2 pos = mix(vec2(1.0), vertex, distortion).xy;
	float time = timer * speed + pos.x * vertex.y;
	float diff = pow(maxStrength - minStrength, 2.0);
	float strength = clamp(minStrength + diff + sin(time / interval) * diff, minStrength, maxStrength) * strengthScale;
	float wind = (sin(time) + cos(time * detail)) * strength * max(0.0, (1.0-uv.y) - heightOffset);
	
	return wind;
}

void vertex() {
	world_pos.x = MODEL_MATRIX[3][0];
	world_pos.y = MODEL_MATRIX[3][1];
	
	VERTEX.x += getWind(VERTEX.xy, UV, TIME);
	
	// Player interaction
	float player_distance = distance(world_pos, player_pos);
	float player_direction = sign(world_pos.x - player_pos.x); 
	player_mask = smoothstep(player_radius, 0, player_distance);
	grass_skew = skew * player_mask * player_direction;
	
	if (grass_skew != 0.0) {
	    VERTEX.x += max(0.0, (1.0-UV.y) - heightOffset) * (grass_skew / 12.0);
	}
}