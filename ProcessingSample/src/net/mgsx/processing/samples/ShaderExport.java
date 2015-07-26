package net.mgsx.processing.samples;

import gifAnimation.*;

import java.io.File;

import processing.core.*;
import processing.opengl.PGraphicsOpenGL;
import processing.opengl.PShader;

/**
 * Applet configuration : 
 * - width, height to define export resolution
 * - src : source shader(s) file/folder (default is data)
 * - dst : images/animations destination folder (default is export)
 * - animation : yes/no to force no animation (default is yes)
 * - fps : frames per second (default is 2)
 * - duration : animation duration (default is 4)
 */
@SuppressWarnings("serial")
public class ShaderExport extends PApplet 
{
	float fps; 
	float duration; 
	boolean noAnimation;
	PImage picture;
	
	public void setup() 
	{
	  size(getWidth(), getHeight(), P2D);
	  noStroke();
	  
	  File src = new File(getParameter("src", "data"));
	  File dst = new File(getParameter("dst", "export"));
	  
	  noAnimation = "no".equals(getParameter("animation"));
	  fps = getParameter("fps", 2.0f);
	  duration = getParameter("duration", 4.0f);
	  
	  picture = loadImage("picture.png");
	  
	  dst.mkdirs();
	  
	  if(src.isDirectory())
	  {
		  for(File file : src.listFiles())
		  {
			  exportShader(file, dst);
		  }		  
	  }
	  else
	  {
		  exportShader(src, dst);
	  }
	  
	  exit();
	}
	
	float getParameter(String name, float defaultValue)
	{
		String value = getParameter(name);
		if(value != null)
		{
			return Float.parseFloat(value);
		}
		return defaultValue;
	}
	
	String getParameter(String name, String defaultValue)
	{
		String value = getParameter(name);
		if(value != null)
		{
			return value;
		}
		return defaultValue;
	}

	private void exportShader(File shaderFile, File dstFolder)
	{
		System.out.println(shaderFile.getName());
		  
		PShader shader = loadShader(shaderFile.getAbsolutePath());
	  
		// we need to bind/unbind shader to request variable location.
		shader.bind();
		boolean hasTime = ((PGraphicsOpenGL)g).pgl.getUniformLocation(shader.glProgram, "time") >= 0;
		shader.unbind();
		
		shader.set("resolution", (float)width, (float)height);
		shader.set("picture", picture);
		
		shader(shader);

		if(hasTime && !noAnimation)
		{
			exportAnimation(shader, shaderFile, dstFolder);
		}
		else
		{
			if(hasTime)
			{
				shader.set("time", 0f);
			}
			exportScreenshot(shader, shaderFile, dstFolder);
		}
		
		shader.dispose();
	}
	
	private void exportScreenshot(PShader shader, File shaderFile, File dstFolder)
	{
	  rect(0, 0, width, height);
	  
	  File dstFile = new File(dstFolder, getShaderName(shaderFile) + ".png");
	  
	  save(dstFile.getPath());
	}
	
	private void exportAnimation(PShader shader, File shaderFile, File dstFolder)
	{
		File dstFile = new File(dstFolder, getShaderName(shaderFile) + ".gif");
		
		  GifMaker gifExport = new GifMaker(this, dstFile.getPath());
		  gifExport.setRepeat(0); // make it an "endless" animation
		  
		  int frames = (int)(fps * duration);
		  for(int f=0 ; f<frames ; f++)
		  {
			  System.out.println((f+1) + "/" + frames);
			  
			  float time = (float)f / fps;
			  shader.set("time", time);
			  rect(0, 0, width, height);
			  gifExport.setDelay((int)(1000.f / fps));
			  gifExport.addFrame();
		  }
		  
		  gifExport.finish();
	}
	
	private String getShaderName(File file)
	{
		String name = file.getName();
		if (name.indexOf(".") > 0)
		    name = name.substring(0, name.lastIndexOf("."));
		return name;
	}

}
