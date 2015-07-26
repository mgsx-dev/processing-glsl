/**
No let's back to perlin with our FM noise.
*/
#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 resolution;

float rand(float x){
    return fract(sin(x * 12.9898) * 43758.5453);
}

float noise(float x, float frequency)
{
  float v = x * frequency;

  float ix1 = floor(v);
  float ix2 = floor(v + 1.0);

  float fx = fract(x);

  return mix(rand(ix1), rand(ix2), fx);
}

float fmnoise(float x, float freq, float fm)
{
  float range = fm * freq;

  float f = (noise(x, freq) - 0.5) * 2.0 * range + freq;

  return noise(x, f);
}

/**
Here is our perlin FM noise
*/
float pfmnoise(float x, float freq, int steps, float persistence, float fm)
{
  float value = 0.0;
  float ampl = 1.0;
  float sum = 0.0;
  for(int i=0 ; i<steps ; i++)
  {
    sum += ampl;
    value += fmnoise(x, freq, fm) * ampl;
    freq *= 2.0;
    ampl *= persistence;
  }
  return value / sum;
}


void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

/**
So let's try it 
*/
  float y = pfmnoise(position.x + time * 0.1, 1.0, 4, 0.5, 1.0);

  float v = step(position.y, y);
  
	gl_FragColor = vec4(v,v,v,1.0);
}

/**
We can imagine a 2D city by night no ?
*/