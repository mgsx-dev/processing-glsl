#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 resolution;

float dot3(vec3 a, vec3 b)
{
  return a.x * b.x + a.y * b.y + a.z * b.z;
}

float rand(vec3 co){
    return fract(sin(dot3(co.xyz ,vec3(12.9898,78.233, 33.87637))) * 43758.5453);
}

float hermite(float t)
{
  return t * t * (3.0 - 2.0 * t);
}

float noise(vec3 co, float freq)
{
  vec3 v = co * vec3(freq, freq, freq); 
  float ix1 = floor(mod(v.x, freq));
  float iy1 = floor(mod(v.y, freq));
  float iz1 = floor(mod(v.z, freq));
  float ix2 = floor(mod(v.x + 1.0, freq));
  float iy2 = floor(mod(v.y + 1.0, freq));
  float iz2 = floor(mod(v.z + 1.0, freq));

  float fx = hermite(fract(v.x));
  float fy = hermite(fract(v.y));
  float fz = hermite(fract(v.z));

  float mix1 = mix(mix(rand(vec3(ix1, iy1, iz1)), rand(vec3(ix2, iy1, iz1)), fx), mix(rand(vec3(ix1, iy2, iz1)), rand(vec3(ix2, iy2, iz1)), fx), fy);
  float mix2 = mix(mix(rand(vec3(ix1, iy1, iz2)), rand(vec3(ix2, iy1, iz2)), fx), mix(rand(vec3(ix1, iy2, iz2)), rand(vec3(ix2, iy2, iz2)), fx), fy);

  return mix(mix1, mix2, fz);
}

float pnoise(vec3 co, float freq, int steps, float persistence)
{
  float value = 0.0;
  float ampl = 1.0;
  float sum = 0.0;
  for(int i=0 ; i<steps ; i++)
  {
    sum += ampl;
    value += noise(co, freq) * ampl;
    freq *= 2.0;
    ampl *= persistence;
  }
  return value / sum;
}

void main( void ) {

  vec2 position = gl_FragCoord.xy / resolution.xy;

  float delta = 1.0 / 3.0;

  float offset = 57.5;

  float v1 = pnoise(vec3(position, delta * 0.0 + offset), 3.0, 5, 0.5);
  float v2 = pnoise(vec3(position, delta * 1.0 + offset), 3.0, 5, 0.5);
  float v3 = pnoise(vec3(position, delta * 2.0 + offset), 3.0, 5, 0.5);
  float v4 = pnoise(vec3(position, delta * 3.0 + offset), 3.0, 5, 0.5);

  gl_FragColor = vec4(v1, v2, v3, v4);
}
