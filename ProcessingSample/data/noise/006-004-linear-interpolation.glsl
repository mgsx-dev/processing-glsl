/**
Let's go to understand linear interpolation
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

/**
Just linear interpolation 
*/
  float fx = fract(x);

  return mix(rand(ix1), rand(ix2), fx);
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

  float y = noise(position.x + time * 0.1, 10.0);

  float v = step(position.y, y);
  
	gl_FragColor = vec4(v,v,v,1.0);
}

/**
we see that bars are now interpolated but there is beacks on edges.
*/