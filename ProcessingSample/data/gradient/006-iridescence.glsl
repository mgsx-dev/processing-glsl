/**
So let's change our color model and switch to a color model closest to physical phenomena : Iridescence.

Rainbow is a linear light frequency decomposition. So we need to work with light frequency instead of tint.

*/
#define PROCESSING_COLOR_SHADER

uniform vec2 resolution;

/**
This function convert a wave length to a color.

Wave length is the inverse of frequency so it will be easy to convert frequency to wave length latter.
*/
vec4 wl_to_rgb(float wl)
{

/**
We slice wave length in multiple parts and for each make a gradient.
Those values are defined by [physical laws](https://en.wikipedia.org/wiki/Spectral_color)
*/
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

/**
Then color is scaled to gamma factor (again from physical laws)
*/
    float g = 0.80;
    vec3 gamma = vec3(g,g,g);
    color = pow(color, gamma);

/**
Now since human perseption is limited, we encode visible spectrum in
alpha channel : infra red and ultra violet will have no opacity.
*/
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

/**
Here is our final function scaling from 0-1 to frequencies and converting frequency to wave length
*/
vec4 frequency_to_rgb(float position)
{
/**
We mix from minimum to maximum human visible frequency
*/
  float f = mix(385.0, 785.0, position);

/**
Convert it to wave length : 300000 is light speed
*/
  float wavelen = 300000.0 / f;

/**
and then return back the final color
*/
  return wl_to_rgb(wavelen);
}

void main( void ) {

  vec2 position = gl_FragCoord.xy / resolution.xy;
  
  float v = position.x;

/**
So let's test our rainbow.
*/
  vec4 rainbow = frequency_to_rgb(v);

/**
Since we have an alpha channel containing visible spectre, we mix rainbow color with
a full white color (representing lightened clouds).
*/
  vec3 color = mix(vec3(1.0, 1.0, 1.0), rainbow.rgb, rainbow.a);

  gl_FragColor = vec4(color, 1.0);
}
/**
Hopefully, the result looks good.
*/