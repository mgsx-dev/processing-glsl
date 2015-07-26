/**
Result is nice but because bars are at regular interval, result
is not natural (too digital).
We need to not have those equal spaces between bars, so we will introduce randomness in frequency
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

/**
Our frequency modulation noise (FM) function
*/
float fmnoise(float x, float freq, float fm)
{
/**
We will vary requested freqency by fm parameters :
- fm = 0 means no FM at all
- fm = 1 means full FM that is frequency will vary from 0 to 2 * frequency base
*/
  float range = fm * freq;
/**
We use noise to compute a final frequency and scale the result to cover range computed before.
*/
  float f = (noise(x, freq) - 0.5) * 2.0 * range + freq;
/**
Then we returns the final noise.
*/
  return noise(x, f);
}


void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

/**
So let's try a full FM noise at frequency 4 
*/
  float y = fmnoise(position.x + time * 0.1, 4.0, 1.0);

  float v = step(position.y, y);
  
	gl_FragColor = vec4(v,v,v,1.0);
}
