class Grid {
	float x = 0;
	float y = 0;

	// update w/ size
	float w;
	float h;
	// calculated size
	float actualW;
	float actualH;
	// module size
	float size;
	// update w/ w + h
	int cols;
	int rows;

	float minSize = moduleMinSize;

	ArrayList<Module> modules = new ArrayList<Module>();
	ColorList upList = new ColorList();
	ColorList downList = new ColorList();
	ColorList leftList = new ColorList();
	ColorList rightList = new ColorList();
	ColorMatrix upMatrix;
	ColorMatrix downMatrix;
	ColorMatrix leftMatrix;
	ColorMatrix rightMatrix;

	ColorList sortedColors;

	ColorList basic = new ColorList();

	Grid(float _w, float _h) {
		w = _w;
		h = _h;

		// CMYK
		
		basic.add(TColor.newHSV(0, 0, 0.14));
		basic.add(TColor.newHSV((float)57/360, 1, 1));
		basic.add(TColor.newHSV((float)324/360, 1, 0.93));
		basic.add(TColor.newHSV((float)196/360, 1, 0.94));

		// colorMatrix of 2x2
		// upMatrix = new ColorMatrix(2);
		// downMatrix = new ColorMatrix(2);
		// leftMatrix = new ColorMatrix(2);
		// rightMatrix = new ColorMatrix(2);

		// // generates monochrome colors
		// TColor col = TColor.newHSV(random(1), 0.9, 0.9);
		// ColorTheoryStrategy s = new TriadTheoryStrategy();
		// ColorList colors = ColorList.createUsingStrategy(s, col);
		// ColorList moreColors = new ColorRange(colors).getColors(null, 4, 0.05);
		// sortedColors = moreColors.sortByDistance(true);

		generateColors();

		

		update();
	}

	void generateColors() {
		// TColor col = TColor.newHSV(random(1), 0.9, 0.9);
		// ColorTheoryStrategy s = new TetradTheoryStrategy();
		// ColorList colors = ColorList.createUsingStrategy(s, col);
		
		

		// colorMatrix of 2x2
		// upMatrix = new ColorMatrix(2, basic.get(0), 0);
		// downMatrix = new ColorMatrix(2, basic.get(1), 1);
		// leftMatrix = new ColorMatrix(2, basic.get(2), 2);
		// rightMatrix = new ColorMatrix(2, basic.get(3), 3);
		upMatrix = new ColorMatrix(2, basic.getRandom().getLightened(0.9).getDesaturated(0.9), 0);
		downMatrix = new ColorMatrix(2, basic.getRandom().getLightened(0.9).getDesaturated(0.9), 1);
		leftMatrix = new ColorMatrix(2, basic.getRandom().getLightened(0.9).getDesaturated(0.9), 2);
		rightMatrix = new ColorMatrix(2, basic.getRandom().getLightened(0.9).getDesaturated(0.9), 3);

	}

	void update() {
		println("grid is updating modules.");

		minSize = moduleMinSize;

		cols = (int)(w / minSize);
		if(h%minSize == 0) rows = (int)(h / minSize);
		else rows = (int)(h / minSize) + 1;
		size = w / cols;
		actualW = size * cols;
		actualH = size * rows;

		modules.clear();
		for (int i = 0; i<rows; i++){
			for (int j = 0; j<cols; j++){
				modules.add(new Module(x+j*size + (w - actualW) / 2, y+i*size + (h - actualH) / 2, size));
			}
		}

		generateColors();
		updateColorsByMatrix();
		updateColorPath();
	}

	void updateColorPath() {
		int runTime = round(random(5, 10));
		for (int j = 0; j<runTime; j++){
			for (int i = 0; i<basic.size(); i++){
				int mode = round(random(1));
				ArrayList<PVector> thread;
				if (mode == 0){
					thread = getNoisePath(round(random(cols)), 0);
				}
				else {
					thread = getNoisePath(round(random(rows)), 1);
				}
				
				if(j < runTime - 1) {
					paintAThread(thread, basic.get(i), 1);
					} else {
						paintAThread(thread, basic.get(i), 0);
					}
				
			}
		}
	}

	void updateColorsByMatrix() {
		//println("grid is updating colors");

		upList = upMatrix.getColors(cols, rows);
		downList = downMatrix.getColors(cols, rows);
		leftList = leftMatrix.getColors(cols, rows);
		rightList = rightMatrix.getColors(cols, rows);


		for (int i = 0; i<rows; i++){
			for (int j = 0; j<cols; j++){
				int index = i*cols + j;
				modules.get(index).patternX.up = upList.get(index);
				modules.get(index).patternX.down = downList.get(index);
				modules.get(index).patternX.left = leftList.get(index);
				modules.get(index).patternX.right = rightList.get(index);
			}
		}
		
	}

	void updateColorsByTheory() {
		for (int i = 0; i<rows; i++){
			for (int j = 0; j<cols; j++){
				int index = i*cols + j;
				modules.get(index).patternX.up = sortedColors.get(0);
				modules.get(index).patternX.down = sortedColors.get(3);
				modules.get(index).patternX.left = sortedColors.get(1);
				modules.get(index).patternX.right = sortedColors.get(2);
			}
		}
	}

	ArrayList<PVector> getNoisePath(int num, int mode) {

		noiseSeed(round(random(100)));
	    float noiseCount = 0;
	    ArrayList<PVector> numbers = new ArrayList<PVector>();


		int begin = (int)random(num);

		
	    for (int i = begin; i<num; i++){
	    	if(mode == 0) {
	    		int a = int(noise(noiseCount)* rows);
	      		numbers.add(new PVector(i, a));
	    	}
	    	else {
	    		int a = int(noise(noiseCount)* cols);
	      		numbers.add(new PVector(a, i));
	    	}
	    	
	    	noiseCount += 0.2;
	    }
	    return numbers;
	}

	void paintAThread(ArrayList<PVector> numbers, TColor c, int mode) {
		ColorTheoryStrategy s = new MonochromeTheoryStrategy();
		ColorList colors = ColorList.createUsingStrategy(s, c);
		colors.adjustBrightness(0.4);
		colors.adjustSaturation(0.2);


		for (int i = 0; i<numbers.size(); i++){
			int x = (int)numbers.get(i).x;
			int y = (int)numbers.get(i).y;
			int index = y * cols + x;

			int runTime = (int)random(5);
			for (int j = 0; j<runTime; j++){
				int r = (int)random(4);
				TColor cnew = colors.getRandom();
				TColor cnear = cnew.getDesaturated(0.3).getLightened(0.5);
				paint(index, cnew, r);
				if(mode != 0) {
					paint(getUpModule(index), cnear, r);
					paint(getDownModule(index), cnear, r);
					paint(getLeftModule(index), cnear, r);
					paint(getRightModule(index), cnear, r);
				}
				

			}
			

		}

	}

	void updateSize(float _w, float _h) {
		w = _w;
		h = _h;
		update();
	}

	void draw() {
		rectMode(CORNER);
		//pushMatrix();
		//translate((w - actualW) / 2, (h - actualH) / 2);
		for (int i = 0; i<modules.size(); i++){
			Module mod = modules.get(i);
			//rect(mod.x, mod.y, mod.size, mod.size);

			//mod.drawWireframes();
			mod.draw();
		}
		//popMatrix();
	}

	void draw(PGraphics canvas) {
		canvas.rectMode(CORNER);
		// center the grid on canvas
		// canvas.pushMatrix();
		// canvas.translate((w - actualW) / 2, (h - actualH) / 2);
		for (int i = 0; i<modules.size(); i++){
			Module mod = modules.get(i);
			//rect(mod.x, mod.y, mod.size, mod.size);

			//mod.drawWireframes(canvas);
			mod.draw(canvas);
		}
		// canvas.popMatrix();

		//upMatrix.draw();
	}


	// get adjacent module index
	int getLeftModule(int index) {
		if(index%cols == 0) return index;
		return index - 1;
	}

	int getRightModule(int index) {
		if(index%cols == cols-1) return index;
		return index + 1;
	}

	int getUpModule(int index) {
		if(index < cols) return index;
		return index - cols;
	}

	int getDownModule(int index) {
		if(index > cols*(rows - 1) - 1) return index;
		return index + cols;
	}

	void paintUp(int index, TColor c) {
		modules.get(index).patternX.up = c;
		if(getUpModule(index) != -1) {
			modules.get(getUpModule(index)).patternX.down = c.getDarkened(random(-0.1, 0.4)).getSaturated(random(-0.1, 0.4));
		}
	}

	void paintDown(int index, TColor c) {
		modules.get(index).patternX.down = c;
		if(getDownModule(index) != -1) {
			modules.get(getDownModule(index)).patternX.up = c.getLightened(random(-0.1, 0.4)).getDesaturated(random(-0.1, 0.4));
		}
	}

	void paintLeft(int index, TColor c) {
		modules.get(index).patternX.left = c;
		if(getLeftModule(index) != -1) {
			modules.get(getLeftModule(index)).patternX.right = c.getDarkened(random(-0.1, 0.4)).getSaturated(random(-0.1, 0.4));
		}
	}

	void paintRight(int index, TColor c) {
		modules.get(index).patternX.right = c;
		if(getRightModule(index) != -1) {
			modules.get(getRightModule(index)).patternX.left = c.getLightened(random(-0.1, 0.4)).getDesaturated(random(-0.1, 0.4));
		}
	}

	void paint(int index, TColor c, int mode) {
		switch (mode){
			case 0 :
				paintUp(index, c);
			break;	

			case 1 :
				paintDown(index, c);
			break;	

			case 2 :
				paintLeft(index, c);
			break;	

			case 3 :
				paintRight(index, c);
			break;	
			
		}

	}
}