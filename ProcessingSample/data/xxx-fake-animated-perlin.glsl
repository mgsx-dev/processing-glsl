#define PROCESSING_COLOR_SHADER

uniform float time;
uniform vec2 resolution;
uniform sampler2D texture;

void main( void ) {

  vec2 position = gl_FragCoord.xy / resolution.xy;

  float stime = time * 0.1;

  float offseta = floor(stime);
  float offsetb = floor(stime + 0.9999);

  vec2 dep = vec2(0.51, 0.49);

  vec4 colora = texture2D(texture, position * 0.5 + offseta * dep);
  vec4 colorb = texture2D(texture, position * 0.5 + offsetb * dep);

  float v = mix(colora.r, colorb.r, fract(stime));

  v = smoothstep(0.4, 0.6, sin(v * 40.0) * 0.5 + 0.5);

  gl_FragColor = vec4(v,v,v,1.0);
}
