public enum Resolution {
	IPHONE_5 (640, 1136), 
	IPHONE_4 (640, 960), 
	IPHONE_3 (320, 480),
	NEXUS_4(768, 1280),
	IPAD_2 (1024, 1024), 
	IPAD (2048, 2048), 
	MBP_15(2880, 1800),
	MBP_13(2560, 1600),
	MBA_11(1366, 768);

	public final int w, h, rw, rh;

	Resolution(int _w, int _h) {
		this.w = _w;
		this.h = _h;
		this.rw = w / gcd(w, h);
		this.rh = h / gcd(w, h);

		// float pw = rw;
		// float ph = rh;

		// while (ph < 600){
		// 	pw *= 2;
		// 	ph *= 2;
		// }

		// this.properW = (int)pw;
		// this.properH = (int)ph;
	}

	int gcd(int x,int y) {  
    	int r;        
        while( y!= 0)        
        {        
            r = x%y;        
            x = y;        
            y = r;        
        }        
    	return x;  
	} 
}

