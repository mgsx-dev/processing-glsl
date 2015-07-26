/**
So let's take another way.
*/
#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 resolution;

float rand(float x){
    return fract(sin(x * 12.9898) * 43758.5453);
}

float hermite(float t)
{
  return t * t * (3.0 - 2.0 * t);
}

float noise(float x, float frequency)
{
  float v = x * frequency;

  float ix1 = floor(v);
  float ix2 = floor(v + 1.0);

  float fx = hermite(fract(x));

  return mix(rand(ix1), rand(ix2), fx);
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

/**
Let compute a first noise at frequency 2
*/
  float x = noise(position.x + time * 0.1, 2.0);

/**
Then we inject that nois in a second noise function
*/
  float y = noise(x * 100.0, 1.0);

/**
We just scale things a little (from 0.3 to 0.7) to give a mountain effect.
*/
  y = 0.3 + y * 0.4;

  float v = step(position.y, y);
  
	gl_FragColor = vec4(v,v,v,1.0);
}

/**
We mix of high and low frequencies
*/