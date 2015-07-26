/**
Let's start with a linear gradient
*/
#define PROCESSING_COLOR_SHADER

uniform vec2 resolution;

void main( void ) {

/**
This is our normalize position on screen (from 0 to 1 in both directions)
*/
	vec2 position = gl_FragCoord.xy / resolution.xy;
	
/**
To draw a linear horizontal gradient, we take x position on screen.
*/
  float v = position.x;

/**
And then make a gray scaled color from this value : same value for red, green and blue channels.
We leave Alpha channel at 1 (full opacity)
*/
	gl_FragColor = vec4(v,v,v,1.0);
}
/**
As expected, we have a nice gradient from black (left) to white (right)
*/