class PatternX {
	float size;

	TColor up = TColor.newHSV((float)204/360, random(0.2), random(0.9, 1));
	TColor down = TColor.newHSV((float)204/360, random(0.2), random(0.9, 1));
	TColor left = TColor.newHSV((float)204/360, random(0.2), random(0.9, 1));
	TColor right = TColor.newHSV((float)204/360, random(0.2), random(0.9, 1));
	// TColor up = TColor.newHSV((float)204/360, random(0.2), random(0.1));
	// TColor down = TColor.newHSV((float)204/360, random(0.2), random(0.1));
	// TColor left = TColor.newHSV((float)204/360, random(0.2), random(0.1));
	// TColor right = TColor.newHSV((float)204/360, random(0.2), random(0.1));

	PatternX(float _size) {
		size = _size;
	}

	void drawWireframes() {
		noFill();
		stroke(0, 0, 1);
		// up
		triangle(0, 0, size / 2, size / 2, size, 0);
		// down
		triangle(0, size, size / 2, size / 2, size, size);
		// left
		triangle(0, 0, size / 2, size / 2, 0, size);
		// right
		triangle(size, 0, size / 2, size / 2, size, size);
	}

	void draw() {
		noStroke();
		fill(up.hue(), up.saturation(), up.brightness());
		triangle(0, 0, size / 2, size / 2, size, 0);
		// up.draw();
		fill(down.hue(), down.saturation(), down.brightness());
		triangle(0, size, size / 2, size / 2, size, size);
		// down.draw();
		fill(left.hue(), left.saturation(), left.brightness());
		triangle(0, 0, size / 2, size / 2, 0, size);
		// left.draw();
		fill(right.hue(), right.saturation(), right.brightness());
		triangle(size, 0, size / 2, size / 2, size, size);
		// right.draw();
	}

	void drawWireframes(PGraphics canvas) {
		canvas.noFill();
		canvas.stroke(0, 0, 1);
		// up
		canvas.triangle(0, 0, size / 2, size / 2, size, 0);
		// down
		canvas.triangle(0, size, size / 2, size / 2, size, size);
		// left
		canvas.triangle(0, 0, size / 2, size / 2, 0, size);
		// right
		canvas.triangle(size, 0, size / 2, size / 2, size, size);
	}

	void draw(PGraphics canvas) {
		canvas.noStroke();
		//canvas.strokeWeight(5);
		canvas.fill(up.hue(), up.saturation(), up.brightness(), 1);
		//canvas.stroke(up.hue(), up.saturation(), up.brightness());
		canvas.triangle(0, 0, size / 2, size / 2, size, 0);
		// up.draw();
		canvas.fill(down.hue(), down.saturation(), down.brightness(), 1);
		//canvas.stroke(down.hue(), down.saturation(), down.brightness());
		canvas.triangle(0, size, size / 2, size / 2, size, size);
		// down.draw();
		canvas.fill(left.hue(), left.saturation(), left.brightness(), 1);
		//canvas.stroke(left.hue(), left.saturation(), left.brightness());
		canvas.triangle(0, 0, size / 2, size / 2, 0, size);
		// left.draw();
		canvas.fill(right.hue(), right.saturation(), right.brightness(), 1);
		//canvas.stroke(right.hue(), right.saturation(), right.brightness());
		canvas.triangle(size, 0, size / 2, size / 2, size, size);
		// right.draw();
	}
}