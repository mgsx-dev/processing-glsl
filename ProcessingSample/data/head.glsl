
#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 resolution;

vec2 rotate(vec2 v, float angle)
{
	float c = cos(angle);
	float s = sin(angle);
	return (v - vec2(0.5, 0.5)) * mat2(c, -s, s, c) + vec2(0.5, 0.5);
}

float pattern(vec2 position, float freq)
{
	return 1.0 - pow(1.0 - abs(sin(position.x * 3.14 * freq)) + sin((position.y + position.x) * 3.14 * freq), 1.1);
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

	position = position * 64.0;

	float sampling = 60.0;

	float v = pattern(position, pattern(position + time * 0.1, 0.1) * 0.1);


	//v = floor(v * sampling) / sampling; 

	gl_FragColor = vec4(v,v,v,1.0);
}