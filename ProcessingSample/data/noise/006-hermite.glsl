/**
The smoothing is good but seam too square / too hard, we need to smooth it more.
*/

#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

/**
A new function helping us to smooth interpolation.
This is based on hermite formula insuring zero derivative at 0 and 1.
In other words, variations around 0 will be very small as well as around 1 and will be
bigger around 0.5.
*/
float hermite(float t)
{
  return t * t * (3.0 - 2.0 * t);
}

float noise(vec2 co, float frequency)
{
  vec2 v = vec2(co.x * frequency, co.y * frequency);

  float ix1 = floor(v.x);
  float iy1 = floor(v.y);
  float ix2 = floor(v.x + 1.0);
  float iy2 = floor(v.y + 1.0);

/**
We smooth interpolation between square with hermite formula.
*/
  float fx = hermite(fract(v.x));
  float fy = hermite(fract(v.y));

  float fade1 = mix(rand(vec2(ix1, iy1)), rand(vec2(ix2, iy1)), fx);
  float fade2 = mix(rand(vec2(ix1, iy2)), rand(vec2(ix2, iy2)), fx);

  return mix(fade1, fade2, fy);
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

  float value = noise(position, 10.0);

	gl_FragColor = vec4(value, value, value,1.0);
}