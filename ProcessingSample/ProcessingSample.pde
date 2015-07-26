PShader shader;

void setup() {
  size(320, 320, P2D);
  noStroke();

  shader = loadShader("gradient/head.glsl");
  shader.set("resolution", float(width), float(height));
  shader.set("picture", loadImage("picture.png"));
}

void draw() {
  shader.set("time", millis() / 1000.0);  
  shader(shader);
  rect(0, 0, width, height);
}

