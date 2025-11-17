shader_type canvas_item;

uniform vec2 Antonia = vec2(640,360);  // screen center, also where player is
uniform float max_distance = 75.0;
uniform float num = 0;

void fragment() {
	if (COLOR.a!=0.0){
		vec2 place = FRAGCOORD.xy;
		float distance_to_playuer = distance(FRAGCOORD.xy, vec2(640,360));
		COLOR.a = clamp(((distance_to_playuer-max_distance)/max_distance*5.0),0.3,1);
	};
}
