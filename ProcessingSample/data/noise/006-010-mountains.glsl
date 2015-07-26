/**
And if Perlin kick in ?
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

/**
create our FM noise from before
*/
float fmnoise(float x, float freq)
{
  float y = noise(x, freq);
  return noise(y * 100.0, 1.0);
}

float pnoise(float co, float freq, int steps, float persistence)
{
  float value = 0.0;
  float ampl = 1.0;
  float sum = 0.0;
  for(int i=0 ; i<steps ; i++)
  {
    sum += ampl;
/**
Then inject it in our perlin function
*/
    value += fmnoise(co, freq) * ampl;
    freq *= 2.0;
    ampl *= persistence;
  }
  return value / sum;
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

/**
call our new pnoise
*/
  float y = pnoise(position.x + time * 0.1 + 0.5, 1.0, 3, 0.5);

  y = 0.3 + y * 0.4;

  float v = step(position.y, y);
  
	gl_FragColor = vec4(v,v,v,1.0);
}

/**
Our mountain looks more cripple than before
*/