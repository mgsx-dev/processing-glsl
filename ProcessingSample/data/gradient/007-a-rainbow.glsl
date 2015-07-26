/**
Now to get our final rainbow, we need to bend it a little
*/
#define PROCESSING_COLOR_SHADER

uniform vec2 resolution;

vec4 wl_to_rgb(float wl)
{

    vec3 color;
    if(wl < 380.0)
    {
      color = vec3(1.0, 0.0, 1.0);
    }
    else if(wl<440.0)
    {
      color = vec3(-(wl - 440.0) / (440.0 - 380.0), 0.0, 1.0);
    }
    else if(wl<490.0)
    {
      color = vec3(0.0, (wl - 440.0) / (490.0 - 440.0), 1.0);
    }
    else if(wl<510.0)
    {
      color = vec3(0.0, 1.0, -(wl - 510.0) / (510.0 - 490.0));
    }
    else if(wl<580.0)
    {
      color = vec3((wl - 510.0) / (580.0 - 510.0), 1.0, 0.0);
    }
    else if(wl<645.0)
    {
      color = vec3(1.0, -(wl - 645.0) / (645.0 - 580.0), 0.0);
    }
    else
    {
      color = vec3(1.0, 0.0, 0.0);
    }

    float g = 0.80;
    vec3 gamma = vec3(g,g,g);
    color = pow(color, gamma);

    float factor;
    if((wl >= 380.0) && (wl<420.0)){
        factor = (wl - 380.0) / (420.0 - 380.0);
    }else if((wl >= 420.0) && (wl<701.0)){
        factor = 1.0;
    }else if((wl >= 701.0) && (wl<781.0)){
        factor = (780.0 - wl) / (780.0 - 700.0);
    }else{
        factor = 0.0;
    }

    return vec4(color, factor);
}

vec4 frequency_to_rgb(float position)
{
  float f = mix(385.0, 785.0, position);

  float wavelen = 300000.0 / f;

  return wl_to_rgb(wavelen);
}

void main( void ) {

  vec2 position = gl_FragCoord.xy / resolution.xy;

/**
We just change the gradient input and voila !
*/
  float v = 0.5 - ((1.0 - position.y - 0.5) - pow(position.x - 0.5, 2.0)) * 4.0;

  vec4 rainbow = frequency_to_rgb(v);

  vec3 color = mix(vec3(1.0, 1.0, 1.0), rainbow.rgb, rainbow.a);

  gl_FragColor = vec4(color, 1.0);
}
