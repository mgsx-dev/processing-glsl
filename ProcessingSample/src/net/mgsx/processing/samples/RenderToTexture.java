package net.mgsx.processing.samples;

import processing.core.PApplet;
import processing.core.PGraphics;
import processing.core.PImage;
import processing.opengl.PShader;

@SuppressWarnings("serial")
public class RenderToTexture extends PApplet {

	PShader shader;

	public void setup() 
	{
		size(getWidth(), getHeight(), P2D);
		noStroke();
		  
	  int texWidth = 256;
	  int texHeight = 256;
	  
	  PGraphics pg = createGraphics(texWidth, texHeight, P2D);
	  pg.quality = 1; // multisample offscreen don't seem to be supported
	  PShader preShader = pg.loadShader("perlin-layers.glsl");
	  preShader.set("resolution", (float)texWidth, (float)texHeight);
	  pg.beginDraw();
	  pg.shader(preShader);
	  pg.rect(0, 0, texWidth, texHeight);
	  pg.endDraw();
	  PImage image = pg.get();
	  pg.dispose();
	  
	  textureWrap(REPEAT);
	  shader = loadShader("head.glsl");
	  shader.set("resolution", (float)width, (float)height);
	  shader.set("texture", image);
	}

	public void draw() 
	{
	  shader.set("time", millis() / 1000.0f);  
	  shader(shader); 
	  rect(0, 0, width, height);
	}

}
