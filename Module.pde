class Module {
  float x;
  float y;
  float size;
  //Tempo tempo;
  PatternX patternX;
  
  Module(float _x, float _y, float _size) {
  	x = _x;
  	y = _y;
  	size = _size;
  	//tempo = new Tempo(size);
  	patternX = new PatternX(size);
  }

  void drawWireframes() {
  	pushMatrix();
  	translate(x, y);
  	patternX.drawWireframes();
  	popMatrix();
  }

  void draw() {
  	pushMatrix();
  	translate(x, y);
  	patternX.draw();
  	popMatrix();
  }

   void drawWireframes(PGraphics canvas) {
  	canvas.pushMatrix();
  	canvas.translate(x, y);
  	patternX.drawWireframes(canvas);
  	canvas.popMatrix();
  }

  void draw(PGraphics canvas) {
  	canvas.pushMatrix();
  	canvas.translate(x, y);
  	patternX.draw(canvas);
  	canvas.popMatrix();
  }
}
