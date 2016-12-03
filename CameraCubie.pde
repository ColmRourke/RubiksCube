/**
  * Author: Colm Rourke   Date:2/12/16
  * Simulates Rubik's Cube (RC), allows user to manipluate this RC as if it were
  * a real RC. 
  * Camera takes in state of real RC and this is the beginging state of the 
  * simulated RC
  * It uses the OpenCV for Processing library By Greg Borenstein
  * https://github.com/atduskgreg/open.cv-processing
  *
  * Instructions
  * Colours are assigned numbers
  * 1=Red, 2=Yellow, 3=Orange, 4=Blue, 5=Green, 6=White
  * Press on numberical key [1-6] and click on the associated colour above to
  * track it. Press the enter key when all colours have been stored.
  * Show all faces to the camera. 
  * 
  * The simulated RC should appear when all faces have been shown.
  * You can manipulate the RC as follows:
  *     Press key according to the move to execute
  *          Move    Key
  *          U       u
  *          U'      U
  *          D       d
  *          D'      D
  *          R       r
  *          R'      R
  *          L       l
  *          L'      L
  *          F       f
  *          F'      F
  *          D       d
  *          D'      D
  */




import processing.opengl.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.*; //for Point and rectangle
import java.util.*;

  Capture video,cam;
  OpenCV opencv;
  PImage src;
  ArrayList<Contour> contoursYellow, contoursRed, contoursOrange, contoursBlue, contoursGreen, contoursWhite; //contours for different colours
  
  // <1> Set the range of Hue values for our filter
  ArrayList<Point> list = new ArrayList<Point>(); //coordinates of colour points on cube
  ArrayList<String> colourList = new ArrayList<String>(); //colour of face
  String[][] colourArray = new String [6][9];
  color[] c = new color[6];
  int[] hues;
  int[] colors;
  int maxColors = 6;
  int faceNumber = 0;  
  int rangeWidth = 10;
  int colorToChange = 0;
  int configureColourAt = 0;
  boolean pressed = false;  //Press enter to set to true and begin when configured
  PImage[] outputs;
  

String [][] colourNames = {
        {"w","r","r","b","r","b","w","g","b"},
        {"b","y","g","r","y","w","y","g","y"},
        {"y","y","y","r","o","o","b","w","g"},
        {"g","g","r","b","w","w","o","y","b"},
        {"o","r","r","o","b","o","g","g","w"},
        {"o","w","r","b","g","y","w","o","o"}};
Cube [] cubies = new Cube[27];

void setup() {
  size(1300, 600, OPENGL);
  noFill();
    video = new Capture(this, "name=/dev/video1,size=640x480,fps=30");
   // video = new Capture(this,640,480);
    video.start();
    delay(500);
    opencv = new OpenCV(this, 640,480);
    delay(500);
  
    contoursRed = new ArrayList<Contour>();
    contoursYellow = new ArrayList<Contour>();
    contoursOrange = new ArrayList<Contour>();
    contoursBlue = new ArrayList<Contour>();
    contoursGreen = new ArrayList<Contour>();
    contoursWhite = new ArrayList<Contour>();
         //default colours
    c[0] = color(149,38,46);   //red
    c[1] = color(186,167,89); //yellow
    c[2] = color(182,94,47);  //orange
    c[3] = color(0,65,141);   //blue
    c[4] = color(32,113,62);   //green
    c[5] = color(125,135,159);  //white
    
    
    // Array for detection colors
    colors = new int[maxColors];
    hues = new int[maxColors];
    
    outputs = new PImage[maxColors];
    cubies=getRc();
}

void draw() {
  background(150);
  video.read();
  image(video,0,0);
  video.loadPixels();
  video.updatePixels();
  
      // <2> Load the new frame of our movie in to OpenCV
    opencv.loadImage(video);
    
    // Tell OpenCV to use color information
    opencv.useColor();
    src = opencv.getSnapshot();
    
    // <3> Tell OpenCV to work in HSV color space.
    opencv.useColor(HSB);
    
    detectColors();
    
    // Show images
    image(src, 0, 0);
    for (int i=0; i<outputs.length; i++) {
      
      if (outputs[i] != null) {
        image(outputs[i], 640-640/6, i*480/6, 640/6, 480/6);
        
        noStroke();
        fill(colors[i]);
       // rect(640, i*480/6, 20, 640/6);
      }
      
    }
    
    // Print text if new color expected
    textSize(20);
    stroke(255);
    fill(255);
    
    text("Configure,press index[1-6] of colour and then click on that colour",10,25);
    text("Red[1],Yellow[2],Orange[3],Blue[4],Green[5],White[6]", 10, 45);
    text("Click Enter to start, please configure first", 10, 65);
   
    
     
    
    //when only 9 colours are detected
  if( list.size() == 9 && pressed==true){
    println("9");
     
     sortCoordinates(); //sort coordinates so they are in order of the colours of the cube face
    //checks if it's face has been entered before
     boolean isSameFace = false;
     for(int otherFaces=0; otherFaces<6; otherFaces++){
       println(colourList.get(4) + " " + colourArray[otherFaces][4]);
      // if(colourArray[otherFaces][4] == colourList.get(4))  //is centre colour that is viewed already present in colourArray
      if(colourArray[0][4]==null){
      for(int i = 0; i < list.size(); i++) { 
        colourArray[faceNumber][i] = colourList.get(i);
        System.out.println(colourArray[faceNumber][i]);
       
        }
      
      }
       else if( colourArray[otherFaces][4]!=null&&colourList.get(4).contains(colourArray[otherFaces][4] ))
       {
         isSameFace=true;
         list.clear();
         colourList.clear();
         println("234");
         break;
       }
     }
     //if new face is shown put into colourArray 
     if(colourArray[0][4]==null||(isSameFace==false && colourArray[0][4] != colourList.get(4) && colourArray[1][4] != colourList.get(4)&& colourArray[2][4] != colourList.get(4)&& colourArray[3][4] != colourList.get(4)&& colourArray[4][4] != colourList.get(4)&& colourArray[5][4] != colourList.get(4)&& colourArray[5][4] != colourList.get(4))){   
       for(int i = 0; i < list.size(); i++) { 
        colourArray[faceNumber][i] = colourList.get(i);
        System.out.println(colourArray[faceNumber][i]);
       
        }
     faceNumber++;
     }
  }
  
  else{
      list.clear();
      colourList.clear();
  }
     
     
  displayContoursBoundingBoxesRed();
  displayContoursBoundingBoxesYellow();
  displayContoursBoundingBoxesOrange();
  displayContoursBoundingBoxesBlue();
  displayContoursBoundingBoxesGreen();
  displayContoursBoundingBoxesWhite();
    
  lights();
  stroke(0);
  translate(900,300);
  rotateX(-mouseY*0.01);
  rotateY(mouseX*-0.01);
  for(int i =0; i<27; i++){
    cubies[i].display();
  }

}


  void keyPressed() {

    
    if(keyCode==ENTER)
    {
      pressed = true;
    }
    if(pressed==true){
       
      for(int colorToChange=0 ; colorToChange<6; colorToChange++) {
  
        int hue = int(map(hue(c[colorToChange]), 0, 255, 0, 180));
        colors[colorToChange] = c[colorToChange];
        hues[colorToChange] = hue;
        
        println("color index " + (colorToChange) + ", value: " + hue);
      }
    }
    //to configure colours, must be done before pressing ENTER
    //red is 1, yellow is 2, orange 3, blue 4, green 5, white 6
    if (key == '1') {
    configureColourAt = 0;
    
  } else if (key == '2') {
    configureColourAt = 1;
    
  } else if (key == '3') {
    configureColourAt = 2;
    
  } else if (key == '4') {
    configureColourAt = 3;
  }
  else if (key == '5') {
    configureColourAt = 4;
  }
  else if (key == '6') {
    configureColourAt = 5;
  }
  else if (key == 'f') 
    F();
  else if (key == 'b')
    B();
  else if (key == 'l')
    L();
  else if (key == 'r')
    R();
  else if (key == 'u')
    U();  
  else if (key == 'd')
    D();
  else if (key == 'F')
    F$();
  else if (key == 'B')
    B$();
  else if (key == 'L')
    L$();
  else if (key == 'R')
    R$();
  else if (key == 'U')
    U$();
  else if (key == 'D')
    D$();
    
  cubies=getRc();

}

/////Rubik's Cube//////

//getRc() assigns each cubie with colours
//Cube[] RC is composed of 8 corners, 12 edges, 6 centers and a middle hidden cube
// each cubie has an x,y,z position along with a colour in the x,y,z (cx,cy,cz) direction

Cube[] getRc (){
  String [][] combination = colourNames;
  String [] corner = new String[8];
  String [] edges = new String[12];
  Cube[] RC =  new Cube [27];
  //corners, colours below refer to the middle colour of a face//////
  //red yellow white
  corner[0] = combination[0][0] + combination[3][2] + combination[4][6];
  RC[0] = new Cube(100, 1, 1, 1, combination[0][0], combination[3][2], combination[4][6]);
  //red yellow blue
  corner[1] = combination[0][2] + combination[4][8] + combination[1][0];
  RC[1] = new Cube(100, -1, 1, 1, combination[0][2], combination[1][0], combination[4][8]);
  //red white green
  corner[2] = combination[0][6] + combination[3][8] + combination[5][0];
  RC[2] = new Cube(100, 1, -1, 1, combination[0][6], combination[3][8], combination[5][0]);
  //red green yellow
  corner[3] = combination[0][8] + combination[5][2] + combination[1][6];
  RC[3] = new Cube(100, -1, -1, 1, combination[0][8], combination[1][6], combination[5][2]);
  //blue orange white
  corner[4] = combination[4][0] + combination[2][2] + combination[3][0];
  RC[4] = new Cube(100, 1, 1, -1, combination[2][2], combination[3][0], combination[4][0]);
  //blue orange yellow
  corner[5] = combination[4][2] + combination[2][0] + combination[1][2];
  RC[5] = new Cube(100, -1, 1, -1, combination[2][0], combination[1][2], combination[4][2]);
  //orange white green
  corner[6] = combination[2][8] + combination[3][6] + combination[5][6];
  RC[6] = new Cube(100, 1, -1, -1, combination[2][8], combination[3][6], combination[5][6]);
  //orange yellow green
  corner[7] = combination[2][6] + combination[1][8] + combination[5][8];
  RC[7] = new Cube(100,-1, -1, -1, combination[2][6], combination[1][8], combination[5][8]);
  
  //edges////////
  //red white
  edges[0]= combination[0][3] + combination[3][5] ;
  RC[8] = new Cube(100, 1, 0, 1, combination[0][3], combination[3][5], "none");
  //red blue
  edges[1]= combination[0][1] + combination[4][7] ;
  RC[9] = new Cube(100, 0, 1, 1, combination[0][1], "none", combination[4][7]);
  //red yellow
  edges[2]= combination[0][5] + combination[1][3] ;
  RC[10] = new Cube(100, -1, 0, 1, combination[0][5], combination[1][3], "none");
  //red green
  edges[3]= combination[0][7] + combination[5][1] ;
  RC[11] = new Cube(100, 0, -1, 1, combination[0][7], "none", combination[5][1]);
  //yellow blue
  edges[4]= combination[1][1] + combination[4][5] ;
  RC[12] = new Cube(100, -1, 1, 0,  "none", combination[1][1], combination[4][5]);
  //yellow green
  edges[5]= combination[1][7] + combination[5][5] ;
  RC[13] = new Cube(100, -1, -1, 0, "none", combination[1][7], combination[5][5]);
  //white blue
  edges[6]= combination[3][1] + combination[4][3] ;
  RC[14] = new Cube(100, 1, 1, 0,  "none", combination[3][1], combination[4][3]);
  //white green
  edges[7]= combination[3][7] + combination[5][3] ;
  RC[15] = new Cube(100, 1, -1, 0, "none", combination[3][7], combination[5][3]);
  //orange blue
  edges[8]= combination[2][1] + combination[4][1] ;
  RC[16] = new Cube(100, 0, 1, -1, combination[2][1], "none", combination[4][1]);
  //orange yellow
  edges[9]= combination[2][3] + combination[1][5] ;
  RC[17] = new Cube(100, -1, 0, -1, combination[2][3], combination[1][5], "none");
  //orange white
  edges[10]=combination[2][5] + combination[3][3] ;
  RC[18] = new Cube(100, 1, 0, -1, combination[2][5], combination[3][3], "none");
  //orange green 
  edges[11]= combination[2][7] + combination[5][7] ;
  RC[19] = new Cube(100, 0, -1, -1, combination[2][7], "none", combination[5][7]);
  
  ////the black centre cube////
  RC[20] = new Cube(100, 0, 0, 0, "none", "none", "none");
  
  ////the center pieces////  their positions are wrong
  RC[21] = new Cube(100, 0, 0, 1, "r", "none", "none");
  RC[22] = new Cube(100, -1, 0, 0, "none", "y", "none");
  RC[23] = new Cube(100, 0, 0, -1, "o", "none", "none");
  RC[24] = new Cube(100, 1, 0, 0, "none", "w", "none");
  RC[25] = new Cube(100, 0, 1, 0, "none", "none", "b");
  RC[26] = new Cube(100, 0, -1, 0, "none", "none", "g");

 return RC;

}

/////MOVES//////

void F (){
  clockFace(0);
  int[] FaceNumbers = {4,1,5,3};
  int[] colourNumbers = {6,7,8,0,3,6,2,1,0,8,5,2};
  clockSides(FaceNumbers, colourNumbers);
}
void F$(){
  antiClockFace(0);
  int[] FaceNumbers = {4,1,5,3};
  int[] colourNumbers = {6,7,8,0,3,6,2,1,0,8,5,2};
  antiClockSides(FaceNumbers, colourNumbers);
}

void B()
{
  clockFace(2);
  int[] FaceNumbers = {4,3,5,1};
  int[] colourNumbers = {2,1,0,0,3,6,6,7,8,8,5,2};
  clockSides(FaceNumbers, colourNumbers);  
}

void B$()
{
  antiClockFace(2);
  int[] FaceNumbers = {4,3,5,1};
  int[] colourNumbers = {2,1,0,0,3,6,6,7,8,8,5,2};
  antiClockSides(FaceNumbers, colourNumbers);
}
void L(){
  
  clockFace(3);
  int[] FaceNumbers = {4,0,5,2};
  int[] colourNumbers = {0,3,6,0,3,6,0,3,6,8,5,2};
  clockSides(FaceNumbers, colourNumbers);    
}

void L$(){
  antiClockFace(3);
  int[] FaceNumbers = {4,0,5,2};
  int[] colourNumbers = {0,3,6,0,3,6,0,3,6,8,5,2};
  antiClockSides(FaceNumbers, colourNumbers);
}

void R(){
  
  clockFace(1);
  int[] FaceNumbers = {4,2,5,0};
  int[] colourNumbers = {8,5,2,0,3,6,8,5,2,8,5,2};
  clockSides(FaceNumbers, colourNumbers);

}

void R$(){  
  antiClockFace(1);
  int[] FaceNumbers = {4,2,5,0};
  int[] colourNumbers = {8,5,2,0,3,6,8,5,2,8,5,2};
  antiClockSides(FaceNumbers, colourNumbers);
}

void U(){
  antiClockFace(4);
  int[] FaceNumbers = {0,3,2,1};
  int[] colourNumbers = {2,1,0,2,1,0,2,1,0,2,1,0};
  clockSides(FaceNumbers, colourNumbers);
}

void U$(){
  antiClockFace(4);
  int[] FaceNumbers = {0,3,2,1};
  int[] colourNumbers = {2,1,0,2,1,0,2,1,0,2,1,0};
  antiClockSides(FaceNumbers, colourNumbers);
}

void D(){
  clockFace(5);
  int[] FaceNumbers = {0,1,2,3};
  int[] colourNumbers = {6,7,8,6,7,8,6,7,8,6,7,8};
  clockSides(FaceNumbers, colourNumbers);
}

void D$(){
  antiClockFace(5);
  int[] FaceNumbers = {0,1,2,3};
  int[] colourNumbers = {6,7,8,6,7,8,6,7,8,6,7,8};
  antiClockSides(FaceNumbers, colourNumbers);
}
//clockFace turns the face inputted clockwise 
void clockFace(int faceNumber){
  String[] temp= new String [9];
  temp[2]=colourNames[faceNumber][0];
  temp[5]=colourNames[faceNumber][1];
  temp[8]=colourNames[faceNumber][2];
  temp[1]=colourNames[faceNumber][3];
  temp[4]=colourNames[faceNumber][4];
  temp[7]=colourNames[faceNumber][5];
  temp[0]=colourNames[faceNumber][6];
  temp[3]=colourNames[faceNumber][7];
  temp[6]=colourNames[faceNumber][8];
  
  colourNames[faceNumber]=temp;
}
//antiClockFace turns the face inputted anticlockwise
void antiClockFace(int faceNumber){
  String[] temp= new String [9];
  temp[6]=colourNames[faceNumber][0];
  temp[3]=colourNames[faceNumber][1];
  temp[0]=colourNames[faceNumber][2];
  temp[7]=colourNames[faceNumber][3];
  temp[4]=colourNames[faceNumber][4];
  temp[1]=colourNames[faceNumber][5];
  temp[8]=colourNames[faceNumber][6];
  temp[5]=colourNames[faceNumber][7];
  temp[2]=colourNames[faceNumber][8];
  
  colourNames[faceNumber]=temp;
}

//as the face twists so does the sides, clockSides turns the sides clockwise, faceNumbers are the faces affected, colourNumbers are the colours affected  
void clockSides(int faceNumbers[], int colourNumbers[]){
  String temp2[] = new String [12];
  int index=0;
  int i = 0;
  int count = 0;
  while(index !=12)
  {
   if(count!=0 && count%3==0){
      i++;
    }
    temp2[index]= colourNames[faceNumbers[i]][colourNumbers[index]];
    count++;
    index++;
  }
 index=9;
 i=0;
 count=0;
 while(count !=12)
  {
    if(count!=0 && count%3==0){
      i++;
    }
    colourNames[faceNumbers[i]][colourNumbers[count]] = temp2[index%12];
    count++;
    index++;
  }
 temp2 = new String[12];
}

//as the face twists so does the sides, antiClockSides turns the sides antiClockwise, faceNumbers are the faces affected, colourNumbers are the colours affected  
void antiClockSides(int faceNumbers[], int colourNumbers[]){
  String temp2[] = new String [12];
  int index=0;
  int i = 0;
  int count = 0;
  while(index !=12)
  {
   if(count!=0 && count%3==0){
      i++;
    }
    temp2[index]= colourNames[faceNumbers[i]][colourNumbers[index]];
    count++;
    index++;
  }
 index=3;
 i=0;
 count=0;
 while(count !=12)
  {
    if(count!=0 && count%3==0){
      i++;
    }
    colourNames[faceNumbers[i]][colourNumbers[count]] = temp2[index%12];
    count++;
    index++;
  }
 temp2 = new String[12];
}

class Cube {
  // Position, velocity vectors
  PVector position;
  // Vertices of the cube
  PVector[] vertices = new PVector[24];
  // width, height, depth
  int sizeOfCube, x, y, z;
  String cx,cy,cz;
  // colors for faces of cube
  color[] quadBG = new color[7];

  Cube(int s, int x,int y,int z, String cx, String cy, String cz) {
    this.sizeOfCube = s;
    //colours
    // Colors are hardcoded
    quadBG[0] = color(255, 0, 0); //red          
    quadBG[1] = color(255, 255, 0); //yellow       
    quadBG[2] = color(255, 255, 255); //white            
    quadBG[3] = color(255, 165, 0); //orange          
    quadBG[4] = color(0, 128, 0); // green
    quadBG[5] = color(0, 0, 255); // blue     
    quadBG[6] = color(0,0,0); //black
    
    for(int i =0; i<quadBG.length; i++){
      quadBG[i] = color(0,0,0);
    }
    //r y o w b g
    if(cx.equals("r")){
       quadBG[0] = color(255, 0, 0); //red  
       quadBG[3] = color(255, 0, 0);           
    }
    else if (cx.equals("y")){
       quadBG[0] = color(255, 255, 0); 
       quadBG[3] = color(255, 255, 0); //yellow     
    }
    else if (cx.equals("o"))
    {
       quadBG[0] = color(255, 165, 0);   
       quadBG[3] = color(255, 165, 0); //orange          
    }
    else if (cx.equals("w"))
    {
       quadBG[0] = color(255, 255, 255);  
       quadBG[3] = color(255, 255, 255); //white       
    }
    else if (cx.equals("b"))
    {
       quadBG[0] = color(0, 0, 255); 
       quadBG[3] = color(0, 0, 255); //blue         
    }
    else if (cx.equals("g"))
    {
       quadBG[0] = color(0, 128, 0); //red  
       quadBG[3] = color(0, 128, 0); //orange          
    }
    
    //y direction
    if(cy.equals("r")){
       quadBG[1] = color(255, 0, 0); //red  
       quadBG[2] = color(255, 0, 0);           
    }
    else if (cy.equals("y")){
       quadBG[1] = color(255, 255, 0); 
       quadBG[2] = color(255, 255, 0); //yellow     
    }
    else if (cy.equals("o"))
    {
       quadBG[1] = color(255, 165, 0);   
       quadBG[2] = color(255, 165, 0); //orange          
    }
    else if (cy.equals("w"))
    {
       quadBG[1] = color(255, 255, 255);  
       quadBG[2] = color(255, 255, 255); //white       
    }
    else if (cy.equals("b"))
    {
       quadBG[1] = color(0, 0, 255); 
       quadBG[2] = color(0, 0, 255); //blue         
    }
    else if (cy.equals("g"))
    {
       quadBG[1] = color(0, 128, 0); //red  
       quadBG[2] = color(0, 128, 0); //orange          
    }
    //z direction
    if(cz.equals("r")){
       quadBG[4] = color(255, 0, 0); //red  
       quadBG[5] = color(255, 0, 0);           
    }
    else if (cz.equals("y")){
       quadBG[4] = color(255, 255, 0); 
       quadBG[5] = color(255, 255, 0); //yellow     
    }
    else if (cz.equals("o"))
    {
       quadBG[4] = color(255, 165, 0);   
       quadBG[5] = color(255, 165, 0); //orange          
    }
    else if (cz.equals("w"))
    {
       quadBG[4] = color(255, 255, 255);  
       quadBG[5] = color(255, 255, 255); //white       
    }
    else if (cz.equals("b"))
    {
       quadBG[4] = color(0, 0, 255); 
       quadBG[5] = color(0, 0, 255); //blue         
    }
    else if (cz.equals("g"))
    {
       quadBG[4] = color(0, 128, 0); //red  
       quadBG[5] = color(0, 128, 0); //orange          
    }
       
    // Start in center
    position = new PVector();
   
    this.position.x=x*s; // gets x, -1<=x<=1, multpilies it by size of cube
    this.position.y=y*s;
    this.position.z=z*s;
    
    // cube composed of 6 quads
    //front
    float point = sizeOfCube/2;
    vertices[0] = new PVector(-point, -point, point);
    vertices[1] = new PVector(point, -point, point);
    vertices[2] = new PVector(point, point, point);
    vertices[3] = new PVector(-point, point, point);
    //left
    vertices[4] = new PVector(-point, -point, point);
    vertices[5] = new PVector(-point, -point, -point);
    vertices[6] = new PVector(-point, point, -point);
    vertices[7] = new PVector(-point, point, point);
    //rigpointt
    vertices[8] = new PVector(point, -point, point);
    vertices[9] = new PVector(point, -point, -point);
    vertices[10] = new PVector(point, point, -point);
    vertices[11] = new PVector(point, point, point);
    //back
    vertices[12] = new PVector(-point, -point, -point); 
    vertices[13] = new PVector(point, -point, -point);
    vertices[14] = new PVector(point, point, -point);
    vertices[15] = new PVector(-point, point, -point);
    //top
    vertices[16] = new PVector(-point, -point, point);
    vertices[17] = new PVector(-point, -point, -point);
    vertices[18] = new PVector(point, -point, -point);
    vertices[19] = new PVector(point, -point, point);
    //bottom
    vertices[20] = new PVector(-point, point, point);
    vertices[21] = new PVector(-point, point, -point);
    vertices[22] = new PVector(point, point, -point);                           
    vertices[23] = new PVector(point, point, point);                           
    
  } 
  // Cube shape itself
  void drawCube() {
    // Draw cube
    for (int i=0; i<6; i++) {
      fill(quadBG[i]);
      beginShape(QUADS);
      for (int j=0; j<4; j++) {
        vertex(vertices[j+4*i].x, vertices[j+4*i].y, vertices[j+4*i].z);
      }
      endShape();
    }
  }
  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    stroke(0); //outline cubies
    strokeWeight(10);
    drawCube(); // Farm out shape to another method

    popMatrix();
  }
}

//////////////////////
  // Detect Functions
  //////////////////////
  
void detectColors() {
      
    for (int i=0; i<hues.length; i++) {
      
      if (hues[i] <= 0) continue;
      
      opencv.loadImage(src);
      opencv.useColor(HSB);
      
      // <4> Copy the Hue channel of our image into 
      //     the gray channel, which we process.
      opencv.setGray(opencv.getH().clone());
      
      int hueToDetect = hues[i];
      //println("index " + i + " - hue to detect: " + hueToDetect);
      
      // <5> Filter the image based on the range of 
      //     hue values that match the object we want to track.
      opencv.inRange(hueToDetect-rangeWidth/2, hueToDetect+rangeWidth/2);
      
      //opencv.dilate();
      opencv.erode();
      
      // TO DO:
      // Add here some image filtering to detect blobs better
      
      // <6> Save the processed image for reference.
      outputs[i] = opencv.getSnapshot();
    
    
    // <7> Find contours in our range image.
    //     Passing 'true' sorts them by descending area.
    
    if (outputs[0] != null) {
      
      opencv.loadImage(outputs[0]);
      
      contoursRed = opencv.findContours(true,true);
       //displayContoursBoundingBoxesRed();
    }
     if (outputs[1] != null) {
      
         opencv.loadImage(outputs[1]);
      
         contoursYellow = opencv.findContours(true,true);
    }
     if (outputs[2] != null) {
      
         opencv.loadImage(outputs[2]);
      
         contoursOrange = opencv.findContours(true,true);
    }
     if (outputs[3] != null) {
      
        opencv.loadImage(outputs[3]);
      
        contoursBlue = opencv.findContours(true,true);
    }
      if (outputs[4] != null) {
      
        opencv.loadImage(outputs[4]);
      
        contoursGreen = opencv.findContours(true,true);
    }
       if (outputs[5] != null) {
      
        opencv.loadImage(outputs[5]);
      
        contoursWhite = opencv.findContours(true,true);
    }
  
  }
}
  
  
  
void sortCoordinates (){
  
     int[] yValues = new int [9];
     int[] xValues = new int [9];
     
     
     //sort y keeping x and colourName respective
     int i=0;
     for (Point p : list){
       xValues[i]=p.x;
       yValues[i]=p.y;
       i++;
     }
      int j,k,first,temp1,temp2;
      String colourTemp;
      for( j= yValues.length-1; j>0; j--)
      {
        first = 0;
        for(k = 1; k <= j; k++)
        {
          if( yValues[k] > yValues[first])
          first = k;
        }
        temp1 = yValues[first];
        temp2 = xValues[first];
        colourTemp = colourList.get(first);
        yValues[first] = yValues[j];
        xValues[first] = xValues[j];
        colourList.set(first,colourList.get(j));
        yValues[j] = temp1;
        xValues[j] = temp2;
        colourList.set(j,colourTemp);
      }
      
      //gets next 3 smallest y values and sorts thier smallest x's, keeping y and
      //colour name respective to get correct order of colours
      for(int z =0; z<3; z++)
      {
        first = 0;
        for(int y = 1; y <= z; y++)
        {
          if( xValues[y] > xValues[first])
          first = y;
        }
        temp1 = yValues[first];
        temp2 = xValues[first];
        colourTemp = colourList.get(first);
        yValues[first] = yValues[z];
        xValues[first] = xValues[z];
        colourList.set(first,colourList.get(z));
        yValues[z] = temp1;
        xValues[z] = temp2;
        colourList.set(z,colourTemp);
      }
      //gets next 3 smallest y values and sorts thier smallest x's, keeping y and
      //colour name respective
      for(int z =3; z<6; z++)
      {
        first = 3;
        for(int y = 4; y <= z; y++)
        {
          if( xValues[y] > xValues[first])
          first = y;
        }
        temp1 = yValues[first];
        temp2 = xValues[first];
        colourTemp = colourList.get(first);
        yValues[first] = yValues[z];
        xValues[first] = xValues[z];
        colourList.set(first,colourList.get(z));
        yValues[z] = temp1;
        xValues[z] = temp2;
        colourList.set(z,colourTemp);
      }
      //gets last 3 smallest y values and sorts thier smallest x's, keeping y and
      //colour name respective
      for(int z =6; z<9; z++)
      {
        first = 6;
        for(int y = 7; y <= z; y++)
        {
          if( xValues[y] > xValues[first])
          first = y;
        }
        temp1 = yValues[first];
        temp2 = xValues[first];
        colourTemp = colourList.get(first);
        yValues[first] = yValues[z];
        xValues[first] = xValues[z];
        colourList.set(first,colourList.get(z));
        yValues[z] = temp1;
        xValues[z] = temp2;
        colourList.set(z,colourTemp);
      }
}
  
  
  
  void displayContoursBoundingBoxesRed() {
    
    for (int i=0; i<contoursRed.size(); i++) {
      
      Contour contour = contoursRed.get(i);
      Rectangle r = contour.getBoundingBox();
      
      if (r.width < 20 || r.height < 20)
        continue;
      
      stroke(255, 0, 0);
      fill(255, 0, 0, 150);
      strokeWeight(2);
      rect(r.x, r.y, r.width, r.height);
      list.add(new Point(r.x,r.y));
      colourList.add(new String("Red "));
    }
  }
  
  void displayContoursBoundingBoxesYellow() {
    
    for (int i=0; i<contoursYellow.size(); i++) {
      
      Contour contour = contoursYellow.get(i);
      Rectangle r = contour.getBoundingBox();
      if (r.width < 20 || r.height < 20 )
        continue;
      
      stroke(255, 0, 0);
      fill(255, 255, 0, 150);
      strokeWeight(2);
      rect(r.x, r.y, r.width, r.height);
      list.add(new Point(r.x,r.y));
      colourList.add(new String("Yellow "));
  
    }
  }
  
  void displayContoursBoundingBoxesOrange() {
    
    for (int i=0; i<contoursOrange.size(); i++) {
      
      Contour contour = contoursOrange.get(i);
      Rectangle r = contour.getBoundingBox();
      
      if (r.width < 20 || r.height < 20)
        continue;
      
      stroke(255, 0, 0);
      fill(255, 69, 0, 150);
      strokeWeight(2);
      rect(r.x, r.y, r.width, r.height);
      list.add(new Point(r.x,r.y));
      colourList.add(new String("Orange "));
    }
  }
  
  void displayContoursBoundingBoxesBlue() {
    
    for (int i=0; i<contoursBlue.size(); i++) {
      
      Contour contour = contoursBlue.get(i);
      Rectangle r = contour.getBoundingBox();
      
      if (r.width < 20 || r.height < 20)
        continue;
      
      stroke(255, 0, 0);
      fill(0, 0, 255, 150);
      strokeWeight(2);
      rect(r.x, r.y, r.width, r.height);
      list.add(new Point(r.x,r.y));
      colourList.add(new String("Blue "));
  
    }
  }
  void displayContoursBoundingBoxesGreen() {
    
    for (int i=0; i<contoursGreen.size(); i++) {
      
      Contour contour = contoursGreen.get(i);
      Rectangle r = contour.getBoundingBox();
      
      if (r.width < 20 || r.height < 20)
        continue;
      
      stroke(255, 0, 0);
      fill(0, 255, 0, 150);
      strokeWeight(2);
      rect(r.x, r.y, r.width, r.height);
      list.add(new Point(r.x,r.y));
      colourList.add(new String("Green "));
    }
  }
  void displayContoursBoundingBoxesWhite() {
    
    for (int i=0; i<contoursWhite.size(); i++) {
      
      Contour contour = contoursWhite.get(i);
      Rectangle r = contour.getBoundingBox();
      
      if (r.width < 20 || r.height < 20)
        continue;
      
      stroke(255, 255, 255);
      fill(255, 255, 255, 150);
      strokeWeight(2);
      rect(r.x, r.y, r.width, r.height);
      list.add(new Point(r.x,r.y));
      colourList.add(new String("White "));
  
    }
  }
/////////  
// Mouse
////////  
 void mousePressed() {
  color colour = get(mouseX, mouseY);
  c[configureColourAt] = colour; 
  int hue = int(map(hue(c[configureColourAt]), 0, 255, 0, 180));
  hues[colorToChange] = hue;
  println("color index " + (configureColourAt) + ", value: " + hue);
 }
