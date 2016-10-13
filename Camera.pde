//import gab.opencv.*;
//import processing.video.*;

//OpenCV opencv;
//Capture src;
//PImage canny;

//void setup(){
//  src = new Capture( this, 640, 480);
//  size(640,480, P2D);
//  src.start();
  
//  opencv = new OpenCV(this, src);
//  opencv.findCannyEdges(20,75);
//  canny = opencv.getSnapshot();
  
  
//}


//void draw(){
  
//  updatePixels();
//  src.read();
//  image(src,0,0);
  
//  loadPixels();
//  pushMatrix();
//  scale(0.5);
//  image(src, 0, 0);
//  opencv.loadImage(src);
//  opencv.findCannyEdges(20,75);
//  canny = opencv.getSnapshot();
 
  
//  image(canny, src.width, 0);
//  popMatrix();
//  updatePixels();
  
  
//  text("Source", 10 ,25);
//  text("Canny",src.width/2 + 10, 25);
  
//}


//import gab.opencv.*;

//PImage dst;
//OpenCV opencv;
//Capture src;
//ArrayList<Contour> contours;
//ArrayList<Contour> polygons;

//void setup() {
//  //src = loadImage("test.jpg");
//   src = new Capture( this, 640, 480);
//    size(640,480, P2D);
//    src.start();
  
//  size(640, 480);
//  opencv = new OpenCV(this, src);

//  opencv.gray();             //threshold
//  opencv.threshold(0);
//  dst = opencv.getOutput();

//  contours = opencv.findContours();
//  println("found " + contours.size() + " contours");
//}

//void draw() {

  
// updatePixels();
// src.read();
// image(dst, src.width, 0);
// image(src,0,0);

// updatePixels();
// loadPixels();
// pushMatrix();
// scale(0.5);
// image(src, 0, 0);
//  opencv.loadImage(src);
//  opencv.findCannyEdges(20,75);
////  canny = opencv.getSnapshot();
 
  
////  image(canny, src.width, 0);
  
  
////  text("Source", 10 ,25);
////  text("Canny",src.width/2 + 10, 25);
  
//  noFill();
//  strokeWeight(3);
  
//  for (Contour contour : contours) {
//    stroke(0, 255, 0);
//    contour.draw();
    
//    stroke(255, 0, 0);
//    beginShape();
//    for (PVector point : contour.getPolygonApproximation().getPoints()) {
//      vertex(point.x, point.y);
//    }
//    endShape();
//  }
//  popMatrix();
//  updatePixels();
  
//}

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;

int thresh = 70;

int time = millis();
int wait = 50;

void setup() {
  size(640, 480);
  noFill();

    
   // video = new Capture(this, cameras[1]);
   // video.start(); 
    
 // video = new Capture(this, 640/2, 480/2);
video = new Capture(this, "name=/dev/video1,size=320x240,fps=30");
  //initialize OpenCV only once
  opencv = new OpenCV(this, 640/2, 480/2);

  video.start();
}

void draw() {
  scale(2);

  if (millis() - time >= wait){
    //update OpenCV with video feed
   // opencv.loadImage(video);
    video.read();
    opencv.loadImage(video);
    image(video, 0, 0 );

    time = millis();
    opencv.gray();
    opencv.threshold(thresh);
    contours = opencv.findContours();
    for (Contour contour : contours) {
      stroke(0, 255, 0);
      contour.draw();

      stroke(255, 0, 0);
      beginShape();
      for (PVector point : contour.getPolygonApproximation().getPoints()) {
        vertex(point.x, point.y);
      }
      endShape();
    }
  }
}
void mouseDragged(){
  thresh = (int)map(mouseX,0,width,0,255);
}
void captureEvent(Capture c) {
  c.read();
}