class ColorMatrix {
	ColorList[] matrix;
	int size;

	ColorMatrix(int _size) {
		size = _size;

		matrix = new ColorList[size];
		for (int i = 0; i<size; i++){
			matrix[i] = new ColorList();
			for (int j = 0; j<size; j++){
				matrix[i].add(TColor.newHSV(random(1), 0.8, 0.9));
			}
		}

	}

	ColorMatrix(int _size, TColor c, int mode) {
		size = _size;
		matrix = new ColorList[size];

		ColorTheoryStrategy s = new MonochromeTheoryStrategy();
		ColorList colors = ColorList.createUsingStrategy(s, c);
		//ColorList moreColors = new ColorRange(colors).getColors(null, size, 0.05);
		ColorList sortedColors = colors.sortByDistance(true);

		switch (mode){
			case 0 :
				for (int i = 0; i<size; i++){
					matrix[i] = new ColorList();
					for (int j = 0; j<size; j++){
						matrix[i].add(sortedColors.get(j));
					}
				}
			break;
			case 1 :
				for (int i = 0; i<size; i++){
					matrix[i] = new ColorList();
					for (int j = 0; j<size; j++){
						matrix[i].add(sortedColors.get(size - 1 -j));
					}
				}
			break;	
			case 2 :
				for (int i = 0; i<size; i++){
					matrix[i] = new ColorList();
					for (int j = 0; j<size; j++){
						matrix[i].add(sortedColors.get(i));
					}
				}
			break;	
			case 3 :
				for (int i = 0; i<size; i++){
					matrix[i] = new ColorList();
					for (int j = 0; j<size; j++){
						matrix[i].add(sortedColors.get(size - 1 - i));
					}
				}
			break;	
		}
	}

	ColorList getColors(int cols, int rows) {
		ColorList[] lists = new ColorList[size];

		for (int i = 0; i<size; i++){
			lists[i] = getGradientList(matrix[i], rows);
		}

		ColorList list = new ColorList();
		for (int i = 0; i<rows; i++){
			ColorList temp = new ColorList();
			for (int j = 0; j<size; j++){
				temp.add(lists[j].get(i));
			}
			ColorList row = getGradientList(temp, cols);

			for (int j = 0; j<row.size(); j++){
				list.add(row.get(j));
			}
		}
		return list;
	}

	void draw(int x, int y) {
		for (int i = 0; i<size; i++){
			for (int j = 0; j<size; j++){
				TColor c = matrix[i].get(j);
				fill(c.hue(), c.saturation(), c.brightness());
				rect(x+i * 30, y+j* 30, 30, 30);
			}
		}
	}
}

ColorList getGradientList(ColorList gradientSource, int num) {
	ColorGradient gradient = new ColorGradient();
	for (int i = 0; i<gradientSource.size(); i++){
		gradient.addColorAt( i / (float)(gradientSource.size()-1) * num , gradientSource.get(i));
	}
	ColorList list = gradient.calcGradient(0, num);

	return list;
}