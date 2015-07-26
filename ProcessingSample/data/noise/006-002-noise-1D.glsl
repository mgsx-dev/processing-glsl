/**
Now let interpolate some noise values
*/
#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 resolution;

float hermite(float t)
{
  return t * t * (3.0 - 2.0 * t);
}

/**
this is our 1D random function
*/
float rand(float x){
    return fract(sin(x * 12.9898) * 43758.5453);
}

/**
And this is our 1D noise version.
*/
float noise(float x, float frequency)
{
  float v = x * frequency;

  float ix1 = floor(v);
  float ix2 = floor(v + 1.0);

  float fx = hermite(fract(v));

  return mix(rand(ix1), rand(ix2), fx);
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

/**
let's try with a noise at frequency 10
*/
  float y = noise(position.x + time * 0.1, 10.0);

  float v = step(position.y, y);
  
	gl_FragColor = vec4(v,v,v,1.0);
}
