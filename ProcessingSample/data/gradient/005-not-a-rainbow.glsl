/**
Now let's try to paint a rainbow.
*/
#define PROCESSING_COLOR_SHADER

uniform vec2 resolution;

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main( void ) {

  vec2 position = gl_FragCoord.xy / resolution.xy;
  
  float v = position.x;

/**
This time we want to blend from red (infra red) to violet (ultra-violet) to have our rainbow.
*/
  vec3 hsvA = vec3(0.0, 1.0, 1.0);
  vec3 hsvB = vec3(5.0 / 6.0, 1.0, 1.0);

  vec3 hsv = mix(hsvA, hsvB, v);

  vec3 color = hsv2rgb(hsv);

  gl_FragColor = vec4(color, 1.0);
}
/**
The result is not really what we expect, if you have the chance to see a rainbow wright now, you will see that our
image is close but not really the same. We have too much green and too much blue.

Again our color model is not well suited to have a rainbow.

If you don't have time to wait to see a rainbow, just google it and watch pictures :-)
*/