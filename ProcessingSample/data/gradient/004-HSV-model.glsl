/**
To achive what we want, we need to move to another model : HSV.

HSV color model is made of three components :
- hue : the tint from 0 to 260 degrees : 0 is red, 120 is green, 240 is blue, 360 is red and so on.
- saturation : this is the amout of color : 0 is no color (gray), 1 is full color.
- value : this is the amount of light : 0 is black and 1 is white

This model can represent all color as the RGB color model.

Note : in this code, hue range is not 0-360 but 0-6 to simplify computations.

*/
#define PROCESSING_COLOR_SHADER

uniform vec2 resolution;

/**
This function convert a HSV color to an RGB color.
This code is optimized, implementation details are not covered in this chapter.
*/
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
Let's configure our two colors : red and blue but with the HSV model
*/
  vec3 hsvA = vec3(0.0, 1.0, 1.0);
  vec3 hsvB = vec3(2.0 / 3.0, 1.0, 1.0);

/**
Now we mix our two colors with gradient
*/
  vec3 hsv = mix(hsvA, hsvB, v);

/**
But we need to convert it back to RGB model since this is our screen color model.
*/
  vec3 color = hsv2rgb(hsv);

	gl_FragColor = vec4(color, 1.0);
}
/**
The result is what we expect, a nice gradient covering full spectrum from red to blue.
*/