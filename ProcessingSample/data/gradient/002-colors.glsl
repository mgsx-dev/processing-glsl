/**
Now let's blend colors.
*/
#define PROCESSING_COLOR_SHADER

uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;
	
  float v = position.x;

/**
Let's choose two colors : red and yellow
*/
  vec3 colorA = vec3(1.0, 0.0, 0.0);
  vec3 colorB = vec3(1.0, 1.0, 0.0);

/**
We then mix them up with our gradient value
*/
  vec3 color = mix(colorA, colorB, v);

/**
And set it as the screen color (again, with full opcacity)
*/
	gl_FragColor = vec4(color, 1.0);
}
/**
As expected, we have a nice gradient from red (left) to yellow (right) throw Orange at middle screen.
*/