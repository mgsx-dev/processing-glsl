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

float lpnoise(vec2 co, float frequency)
{
  vec2 v = co * frequency;

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

  float slice = 4.0;

  float framex = floor(position.x * slice);
  float framey = floor(position.y * slice);

  float frame = framey * slice + framex;

  vec2 sposition = (position / slice) + vec2(framex, framey);

  float value = lppnoise(vec3(sposition, frame), 10.0, 5, 0.5);

  gl_FragColor = vec4(value, value, value,1.0);
}
