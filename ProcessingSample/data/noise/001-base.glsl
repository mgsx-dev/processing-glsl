/**
Here is our shader base.

We tell Processing that's our shader is a color shader (very basic)
*/
#define PROCESSING_COLOR_SHADER

/**
Then we define 2 uniform parameters
- time : an arbitrary number increasing over the time (in seconds)
- resolution : the screen size in pixels (width and height as 2D vector)

Uniform mean that's these "variables" will have the same value for the shader pass (that is a frame).
Obviosly, these values will varying frame to frame.
These are "variable" in application scope but "constants" in frame scope. 
*/
uniform float time;
uniform vec2 resolution;

/**
Here is our main shader function called for each texel (each screen pixel in our case)
*/
void main( void ) {

/**
First let compute position in screen coordinates form 0 to 1.
gl_FragCoord is in pixel so we need to scale it. That's with we use the resolution uniform to make
our shader independent to screen size.
*/
	vec2 position = gl_FragCoord.xy / resolution.xy;

/**
Finally we set the screen color.
For test purpose, we set Red and Green with x/y position to test it's ok.
We leave blue channel to 0 and alpha channel to 1.
Result is expected to be a wonderfull gradient :
- black to red on X
- black to green on Y
OpenGL use lower left coordinates so we expect the lower-left corner to be black on upper-right to be yellow (red and green)
*/
	gl_FragColor = vec4(position.x, position.y, 0.0,1.0);
}