/**
Enough for the basics, we need to move forward and make some noise !
*/

#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 resolution;

/**
Let's create a random function (some hardware have built-in function to do it).
These magic number help us to emulate randomness, with a given 2D vector this function
generate a random value form 0 (inclusive) to 1 (exclusive).
Note that the same value will be returned for the same coordinates.
*/
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

/**
Now we paint random on screen with animation, like old time television ...
*/
  float value = rand(vec2(position.x + time, position.y + time));

	gl_FragColor = vec4(value, value, value,1.0);
}