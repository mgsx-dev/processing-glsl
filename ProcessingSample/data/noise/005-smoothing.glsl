/**
Pixel noise is cool but we want to smooth it a little.
*/

#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

/**
Our new noise function will fade between all these squares.
*/
float noise(vec2 co, float frequency)
{
  vec2 v = vec2(co.x * frequency, co.y * frequency);

  float ix1 = floor(v.x);
  float iy1 = floor(v.y);

/**
We take adjacent values to interpolate them
*/
  float ix2 = floor(v.x + 1.0);
  float iy2 = floor(v.y + 1.0);

/**
These are fractional parts, that will use to fade values.
*/
  float fx = fract(v.x);
  float fy = fract(v.y);

/**
We mix top-left and top-right squares horizontally
*/
  float fade1 = mix(rand(vec2(ix1, iy1)), rand(vec2(ix2, iy1)), fx);
/**
We mix bottom-left and bottom-right squares horizontally
*/
  float fade2 = mix(rand(vec2(ix1, iy2)), rand(vec2(ix2, iy2)), fx);

/**
And them we mix these vertically to have a nice fade
*/
  return mix(fade1, fade2, fy);
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

  float value = noise(position, 10.0);

	gl_FragColor = vec4(value, value, value,1.0);
}