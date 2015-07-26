/**
Now let's play with time and some basic function.
Let's get some waves with sinusoïdal function :

*/

#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

/**
This value expect to draw 10 diagonal moving waves.
*/
  float value = sin((position.x + position.y) * 10.0 * 3.14 + time) * 0.5 + 0.5;

/**
We don't want to play with color so we set same value for RGB channels
*/
	gl_FragColor = vec4(value, value, value,1.0);
}