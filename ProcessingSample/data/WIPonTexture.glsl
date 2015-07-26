#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 resolution;
uniform sampler2D texture;

float hermite(float t)
{
  return t * t * (3.0 - 2.0 * t);
}

void main( void ) {

  vec2 position = gl_FragCoord.xy / resolution.xy;

  float stime = time * 0.1;

  float layer = floor(stime * 3.0);
  float fade = hermite(fract(stime * 3.0));

  vec4 color = texture2D(texture, position * 1.0);

  float v = mix(color[int(mod(layer, 3.0))], color[int(mod((layer + 1.0), 3.0))], fade);

  v = smoothstep(0.4, 0.6, sin(v * 40.0) * 0.5 + 0.5);

  gl_FragColor = vec4(v,v,v,1.0);
}
