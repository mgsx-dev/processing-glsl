/**
Sometime we need to convert from RGB to HSV. To apply effect on images for instance.
*/
#define PROCESSING_COLOR_SHADER

uniform vec2 resolution;
uniform float time;

/**
This is our texture we will work with
*/
uniform sampler2D picture;

/**
This function convert a RGB color to an HSV color.
This code is optimized, implementation details are not covered in this chapter.
*/
vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;

/**
We compute a 4 seconds fade in from 0 to 1
*/
  float t = fract(time * 0.25);
	
/**
We retreive the picture color at screen position to paint it on screen.
We flip y position to not have picture up side down.
*/
  vec4 source = texture2D(picture, vec2(position.x, 1.0 - position.y));

/**
Then we convert the RGB color to an HSV color
*/
  vec3 hsv = rgb2hsv(source.rgb);

/**
Now we apply our effect : we mix from original to "sepia" image (saturation 0.3, yelow tint)
*/
  hsv = vec3(mix(hsv.x, 1.0 / 6.0, t), mix(hsv.y, 0.3, t), hsv.z);

/**
And then convert it back to RGB model.
*/
  vec3 color = hsv2rgb(hsv);

	gl_FragColor = vec4(color, 1.0);
}