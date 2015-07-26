#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 resolution;

float hermite(float t)
{
  return t * t * (3.0 - 2.0 * t);
}

float dot3(vec3 a, vec3 b)
{
  return a.x * b.x + a.y * b.y + a.z * b.z;
}

float rand(vec3 co){
    return fract(sin(dot3(co.xyz ,vec3(12.9898,78.233, 33.87637))) * 43758.5453);
}

float noise(vec3 co, float freq)
{
  float scale = 1.0 / freq; 
  vec3 v = co * vec3(scale, scale, scale); 
  float ix1 = floor(v.x);
  float iy1 = floor(v.y);
  float iz1 = floor(v.z);
  float ix2 = floor(v.x + 1.0);
  float iy2 = floor(v.y + 1.0);
  float iz2 = floor(v.z + 1.0);

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
    freq *= 0.5;
    ampl *= persistence;
  }
  return value / sum;
}



float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


float noise(vec2 co, float freq)
{
  float scale = 1.0 / freq; 
  vec2 v = co * vec2(scale, scale); 
  float ix1 = floor(v.x);
  float iy1 = floor(v.y);
  float ix2 = floor(v.x + 1.0);
  float iy2 = floor(v.y + 1.0);

  float fx = hermite(fract(v.x));
  float fy = hermite(fract(v.y));

  return mix(mix(rand(vec2(ix1, iy1)), rand(vec2(ix2, iy1)), fx), mix(rand(vec2(ix1, iy2)), rand(vec2(ix2, iy2)), fx), fy);
}

float pnoise(vec2 co, float freq, int steps, float persistence)
{
  float value = 0.0;
  float ampl = 1.0;
  float sum = 0.0;
  for(int i=0 ; i<steps ; i++)
  {
    sum += ampl;
    value += noise(co, freq) * ampl;
    freq *= 0.5;
    ampl *= persistence;
  }
  return value / sum;
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;
	float vtime = time * 0.01f;
	
  float nz = pnoise(vec3(position.x, fract(vtime), position.y), 0.1, 5, /*floor(position.y * 5.0) / 4.0*/ 0.5);

  nz = sin(nz * 57.57) * 0.5 + 0.5;

	gl_FragColor = vec4(nz,nz,nz,1.0);
}