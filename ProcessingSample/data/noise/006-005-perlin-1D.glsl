/**
Now let's implements Perlin 1D
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

/**
Our Perlin Noise 1D version.
*/
float pnoise(float x, float freq, int steps, float persistence)
{
  float value = 0.0;
  float ampl = 1.0;
  float sum = 0.0;
  for(int i=0 ; i<steps ; i++)
  {
    sum += ampl;
    value += noise(x, freq) * ampl;
    freq *= 2.0;
    ampl *= persistence;
  }
  return value / sum;
}


void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

/**
Test it with classic 0.5 persistence and 4 fractal levels
*/
  float y = pnoise(position.x + time * 0.1, 2.0, 5, 0.6);

  float v = step(position.y, y);
  
	gl_FragColor = vec4(v,v,v,1.0);
}

/**
we see multiple fractal levels added together giving a squared mountains
*/