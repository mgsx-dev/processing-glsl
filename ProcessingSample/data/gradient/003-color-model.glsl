/**
Now let's blend a higher color spectrum : from red to blue.

We expect the gradient to cover red, orange, yellow, green, cyan and blue.
*/
#define PROCESSING_COLOR_SHADER

uniform vec2 resolution;

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;
	
  float v = position.x;

/**
Let's configure our two colors : red and blue
*/
  vec3 colorA = vec3(1.0, 0.0, 0.0);
  vec3 colorB = vec3(0.0, 0.0, 1.0);

  vec3 color = mix(colorA, colorB, v);

	gl_FragColor = vec4(color, 1.0);
}
/**
The result is not what we expect, we have red on left (OK), blue on right(OK) but just purple in the middle.

The problem is in our color model. We use RGB model which is not well suited for our needs : In this chapter, red color has
no green component at all, this is the same for the blue color. So when mixing, we have no chance that green channel comeup.
*/