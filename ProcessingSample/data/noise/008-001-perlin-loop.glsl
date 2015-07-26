/**
Noise sound good. But sometimes we need wrappable textures.
So we needs to loop on random table.
So let's add "lp" prefix on loopable function.
*/

#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float hermite(float t)
{
  return t * t * (3.0 - 2.0 * t);
}

/**
Our loopable noise function
*/
float lpnoise(vec2 co, float frequency)
{
  vec2 v = co * frequency;

/**
Here we are working modulus frequency
*/
  float ix1 = floor(mod(v.x, frequency));
  float iy1 = floor(mod(v.y, frequency));
  float ix2 = floor(mod(v.x + 1.0, frequency));
  float iy2 = floor(mod(v.y + 1.0, frequency));

  float fx = hermite(fract(v.x));
  float fy = hermite(fract(v.y));

  float fade1 = mix(rand(vec2(ix1, iy1)), rand(vec2(ix2, iy1)), fx);
  float fade2 = mix(rand(vec2(ix1, iy2)), rand(vec2(ix2, iy2)), fx);

  return mix(fade1, fade2, fy);
}

/**
just rename our pnoise function
*/
float lppnoise(vec2 co, float freq, int steps, float persistence)
{
  float value = 0.0;
  float ampl = 1.0;
  float sum = 0.0;
  for(int i=0 ; i<steps ; i++)
  {
    sum += ampl;
    value += lpnoise(co, freq) * ampl;
    freq *= 2.0;
    ampl *= persistence;
  }
  return value / sum;
}

void main( void ) {

  vec2 position = gl_FragCoord.xy / resolution.xy;

/**
try it scaling our vector by 4 to see loop. Traditionnaly we don't scale it to
have just one full loop.
*/
  float value = lppnoise(position * 4.0, 10.0, 5, 0.5);

  gl_FragColor = vec4(value, value, value,1.0);
}

/**
As expected, we have 16 times the same image and no breaks on edges.
*/