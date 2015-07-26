package net.mgsx.processing.samples;

import processing.core.*;
import processing.opengl.PShader;

@SuppressWarnings("serial")
public class ShaderPreview extends PApplet {

	PShader shader;

	public void setup() 
	{
	  size(getWidth(), getHeight(), P2D);
	  noStroke();

	  String shaderName = getParameter("shader");
	  
	  shader = loadShader(shaderName);
	  shader.set("resolution", (float)width, (float)height);
	  shader.set("picture", loadImage("picture.png"));
	}

	public void draw() 
	{
	  shader.set("time", millis() / 1000.0f);  
	  shader(shader); 
	  rect(0, 0, width, height);
	}

}
