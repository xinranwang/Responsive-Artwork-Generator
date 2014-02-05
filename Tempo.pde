class Tempo {
	float size;
	int[] tempo = {1, 0, 1, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1};
	ArrayList[] grid = new ArrayList[4]; 

	Tempo(float _size) {
		size = _size;
		for(int i = 0; i < grid.length; i++) {
    		grid[i] = new ArrayList<PVector>();
		}
		update();
	}

	void update() {
		for(int i = 0; i < grid.length; i++) {
    		grid[i].clear();
		}

		for(int i = 0; i < tempo.length; i++) {
    		if(tempo[i] == 1) {
		      grid[0].add(new PVector(0, i * size / 16));
		      grid[1].add(new PVector(i * size / 16, size));
		      grid[2].add(new PVector(size, size - i * size / 16));
		      grid[3].add(new PVector(size - i * size / 16, 0));
    		}
  		}
	}

	void draw() {
		for(int i = 0; i < grid.length; i++) {
    		for(int j = 0; j < grid[i].size(); j++) {
      		PVector p1 = (PVector)grid[i].get(j);
      		PVector p2 = (PVector)grid[(i+1)%grid.length].get(grid[i].size() - j - 1);
      		line(p1.x, p1.y, p2.x, p2.y);
    		}
  		}
	}
}