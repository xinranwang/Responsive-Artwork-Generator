class CanvasFrame {
	float x, y, w, h;
	PGraphics canvas;
	float controlBlock = 10;
	
	Grid grid;

	CanvasFrame(float _x, float _y, float _w, float _h) {
		x = _x;
		y = _y;
		w = _w;
		h = _h;

		canvas = createGraphics((int)w, (int)h);
		grid = new Grid(w, h);
	}

	void update() {
		//canvas.clear();
		
		canvas.colorMode(HSB, 1, 1, 1, 1);
		canvas.beginDraw();
		canvas.smooth();
		canvas.background(0, 0, 1);

		//grid.updateColorsByTheory();
		//grid.updateColorsByMatrix();

		grid.draw(canvas);

		//if(save) canvas.dispose();

		canvas.endDraw();


	}

	void draw() {
		image(canvas, x, y);
		if(resize) drawEdge();
	}

	void drawEdge() {
		rectMode(CORNER);
		noFill();
		stroke(1, 1, 1);
		rect(x, y, w, h);

		rectMode(CENTER);
		fill(1, 1, 1);
		noStroke();
		rect(x, y, controlBlock, controlBlock);
		rect(x + w, y, controlBlock, controlBlock);
		rect(x, y + h, controlBlock, controlBlock);
		rect(x + w, y + h, controlBlock, controlBlock);
	}

	void resize(float _w, float _h) {
		if(_w > 0 && _h > 0) {
			w = _w;
			h = _h;
			//canvas.setSize((int)w, (int)h);
			canvas = createGraphics((int)w, (int)h);
			grid.updateSize(w, h);
		}
	}
}