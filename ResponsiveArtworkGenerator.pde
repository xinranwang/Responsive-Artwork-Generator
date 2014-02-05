/*
CanvasFrame - grid 	- modules		-  patternX
					- colorMatrix
			- canvas
*/


import geomerative.*;
import org.apache.batik.svggen.font.table.*;
import org.apache.batik.svggen.font.*;
import toxi.color.*;
import toxi.color.theory.*;
import toxi.util.datatypes.*;
import java.util.*;
import java.awt.event.*;
import processing.pdf.*;

import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;

ControlP5 cp5;
//Slider modMinSize;
Group controlGroup;
Group resizeGroup;

// Textfield ratio_width;
// Textfield ratio_height;
Textfield size_width;
Textfield size_height;
ListBox resolutions;


CanvasFrame myFrame;
boolean resize = false;
boolean drag = false;

float moduleMinSize = 60.0;

Resolution r;
Resolution[] resolutionArray = {Resolution.MBA_11, Resolution.MBP_15, Resolution.MBP_13, Resolution.IPAD, Resolution.IPHONE_5, Resolution.IPHONE_4, Resolution.NEXUS_4};
String[] resolutionNames = {"Macbook Air 11''", "Macbook Pro 15''", "MAcbook Pro 13''", "iPad", "iPhone 5", "iPhone 4", "Nexus 4"};

void setup() {
	size(1280, 800);
  frame.setBackground(new java.awt.Color(0,0,0));
	cp5 = new ControlP5(this);
	RG.init(this);
  	colorMode(HSB, 1, 1, 1, 1);

  	myFrame = new CanvasFrame(10, 10, 500, 500);

  	cp5.addToggle("resize")
  	   .setPosition(width - 300, 100)
  	   .setSize(50, 20)
  	   .setValue(false)
       .setMode(ControlP5.SWITCH);

    controlGroup = cp5.addGroup("group")
    				  .setPosition(width - 300, 150)
    				  .hideBar()
    				  ;
 	resizeGroup = cp5.addGroup("group2")
    				  .setPosition(width - 300, 150)
    				  .hideBar()
    				  .hide()
    				  ;

    cp5.addSlider("moduleMinSize")
		.setPosition(0, 20)
		.setRange(50, 250)
		.setGroup(controlGroup)
		;

    cp5.addButton("updateBackground")
  	   .setPosition(0, 50)
  	   .setSize(90, 20)
  	   .setValue(0)
  	   .setGroup(controlGroup)
       ;

    cp5.addButton("updateColorPath")
  	   .setPosition(100, 50)
  	   .setSize(90, 20)
  	   .setValue(0)
  	   .setGroup(controlGroup)
       ;

    cp5.addButton("updateAllColors")
  	   .setPosition(0, 80)
  	   .setSize(190, 20)
  	   .setValue(0)
  	   .setGroup(controlGroup)
       ;

    cp5.addButton("save")
  	   .setPosition(0, height - 250)
  	   .setSize(100, 20)
  	   .setValue(0)
  	   .setGroup(controlGroup)
       ;

    size_width = cp5.addTextfield("Width")
       .setPosition(0, 20)
       .setSize(40, 20)
       .setGroup(resizeGroup)
       ;

    size_height = cp5.addTextfield("Height")
       .setPosition(60, 20)
       .setSize(40, 20)
       .setGroup(resizeGroup)
       ;

    cp5.addButton("submit")
       .setPosition(130, 20)
       .setSize(80, 20)
       .setGroup(resizeGroup)
       ;

    resolutions = cp5.addListBox("resolutions")
       .setPosition(0, 80)
       //.setSize(100, 100)
       .setBarHeight(15)
       .setItemHeight(20)
       .setGroup(resizeGroup)
       .disableCollapse()
       ;  

    resolutions.captionLabel().style().marginTop = 3;
  	resolutions.captionLabel().style().marginLeft = 3;
  	resolutions.valueLabel().style().marginTop = 3;
  	for (int i = 0; i<resolutionNames.length; i++){
  		resolutions.addItem(resolutionNames[i], i);
  	}

}

void draw() {
	background(0, 0, 0);
	smooth();

	myFrame.update();
	myFrame.draw();

	fill(0, 0, 1);
	int r = gcd(myFrame.canvas.width, myFrame.canvas.height);
	text("Width: " + myFrame.canvas.width + ", Height: " + myFrame.canvas.height, width - 300, 50);
	text("Ratio: " + myFrame.canvas.width / r + ":" + myFrame.canvas.height / r, width - 300, 80);

	if(resize) {
		controlGroup.hide();
		resizeGroup.show();
	} else {
		controlGroup.show();
		resizeGroup.hide();
	}

}

void mousePressed() {
	if(resize && mouseX > myFrame.x+myFrame.w - 10 && mouseX < myFrame.x+myFrame.w + 10
			&& mouseY > myFrame.y+myFrame.h - 10 && mouseY < myFrame.y+myFrame.h + 10) {
		drag = true;
	}
}

void mouseReleased() {
	if(drag) {
		drag = false;
	}
}

void mouseDragged() {
	if (resize && drag) {
		if(keyPressed && key == CODED && keyCode == SHIFT) {
			float r = myFrame.w / myFrame.h;
  			float w = mouseX - myFrame.x;
  			float h = w / r;
  			myFrame.w = w;
  			myFrame.h = h;
  			myFrame.resize(w, h);
		}
		else {
			myFrame.resize(mouseX - myFrame.x, mouseY - myFrame.y);
		}
	}
		
}

  
public void controlEvent(ControlEvent theEvent) {
	if (theEvent.isGroup()) {
    // an event from a group e.g. scrollList
    	//println(theEvent.group().value()+" from "+theEvent.group());
  	}
  	else if (theEvent.isController()) {
    	//println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());

	if(theEvent.controller().name() == "moduleMinSize") {
		myFrame.grid.update();
	}
	if(theEvent.controller().name() == "save") {
		int r = gcd(myFrame.canvas.width, myFrame.canvas.height);
		int rw = myFrame.canvas.width / r;
		int rh = myFrame.canvas.height / r;

		PGraphics pg = createGraphics(myFrame.canvas.width, myFrame.canvas.height, PDF, rw + "by" + rh + "-" + year() + "_" + month()+ "_" + day() + "_" + hour() + "_" + minute() + "_" + second() + "_" + millis() + "_"+".pdf");
		pg.beginDraw();
		pg.colorMode(HSB, 1, 1, 1, 1);
		
		pg.smooth();
		pg.background(0, 0, 1);

		myFrame.grid.draw(pg);

		pg.dispose();
		pg.endDraw();

		println("pdf saved.");
	}
    if(theEvent.controller().name() == "updateBackground") {
    	myFrame.grid.generateColors();
		myFrame.grid.updateColorsByMatrix();
		//myFrame.grid.updateColorPath();
    }

    if(theEvent.controller().name() == "updateColorPath") {
    	//myFrame.grid.generateColors();
		myFrame.grid.updateColorsByMatrix();
		myFrame.grid.updateColorPath();
    }

    if(theEvent.controller().name() == "updateAllColors") {
    	myFrame.grid.generateColors();
		myFrame.grid.updateColorsByMatrix();
		myFrame.grid.updateColorPath();
    }

  	}
  	if(theEvent.isGroup() && theEvent.name().equals("resolutions")) {
    	println("theEvent.group().value(): "+theEvent.group().value());
    	int i = (int)theEvent.group().value();
    	
    	r = resolutionArray[i];
    	setProperSize((float)r.rw/(float)r.rh);
    }
    
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

void setProperSize(float ratio) {
	float w, h;
	if(ratio > 1) {
			w = 800;
			h = w / ratio;	
	}
	else {
		h = 600;
		w = h * ratio;
	}

	myFrame.w = w;
	myFrame.h = h;
	myFrame.resize(w, h);

	//return new PVector(w, h);
}

void submit(int theValue) {
	size_height.submit();
	size_width.submit();

	if(size_height.getStringValue() != "" && size_width.getStringValue() != "") {
		float rw = parseFloat(size_width.getStringValue());
		float rh = parseFloat(size_height.getStringValue());
		//float w, h;
		println("rw: "+rw);
		println("rh: "+rh);

		float ratio = (float)rw / (float)rh;
		setProperSize(ratio);

	} else {
		println("please input all the size parameters.");
	}
	
}




