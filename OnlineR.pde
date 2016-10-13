
import processing.opengl.*;

float inc=1;
Cube[] cubies = new Cube[27]; 
float angle=0;
boolean rPressed = false;
boolean bPressed = false;
void setup() {
  size(600, 600, OPENGL);
  for (int i = 0; i<27; i++)
  {
    cubies[i] = new Cube (100, i );
  }
}
//
void draw() {
  background(200);
  lights();
  stroke(0);
  translate(width/2, height/2);
  rotateX(-mouseY*0.01);
  rotateY(mouseX*-0.01);

  if (keyPressed) {  
    if (key == 'b' && bPressed==false) {//when b is pressed once, rotate cubies
      bPressed=true;
      angle = angle + PI/2; //90 degrees
 
      backRotate();
      
    } 

    else if (key == 'r' && rPressed==false) {//when b is pressed once, rotate cubies
      rPressed=true;
      angle = angle + PI/2; //90 degrees
      rRotate();
    }
   
  }
   else
    {
    for(int c=0;c<cubies.length;c++){
      cubies[c].display();
    }
  }
  
}
void backRotate() {
  float size=100;
  
  for (int i = 0; i<27; i++) {
    float x, y, z;
    x=cubies[i].position.x;
    y=cubies[i].position.y;
    z=cubies[i].position.z;

    if (i==22) {  //centre blue
      cubies[22].rotateCube(angle);
    } else if (cubies[i].position.x==size &&      //top left corner blue 18
      cubies[i].position.y==-size &&
      cubies[i].position.z==size) {

      cubies[i].rotateCube(angle);
    } else if (cubies[i].position.x==size &&      //middle left edge blue 19
      cubies[i].position.y==0 &&
      cubies[i].position.z==size) {

      cubies[i].rotateCube(angle);
    } else if (cubies[i].position.x==size &&      //bottom left corner blue 20
      cubies[i].position.y==size &&
      cubies[i].position.z==size) {

      cubies[i].rotateCube(angle);
    } else if (cubies[i].position.x==0 &&      //top edge blue 21
      cubies[i].position.y==-size &&
      cubies[i].position.z==size) {

      cubies[i].rotateCube(angle);
    } else if (cubies[i].position.x==0 &&      //bottom edge blue 23
      cubies[i].position.y==size &&
      cubies[i].position.z==size) {

      cubies[i].rotateCube(angle);
    } else if (cubies[i].position.x==-size &&      //top right corner blue 24
      cubies[i].position.y==-size &&
      cubies[i].position.z==size) {

      cubies[i].rotateCube(angle);
    } else if (cubies[i].position.x==-size &&      //middle right edge 25
      cubies[i].position.y==0 &&
      cubies[i].position.z==size) {

      cubies[i].rotateCube(angle);
    } else if (cubies[i].position.x==-size &&      //bottom right blue
      cubies[i].position.y==size &&
      cubies[i].position.z==size) {

      cubies[i].rotateCube(angle);
    } else {
      cubies[i].display();
    }

  }
 
}
void rRotate() {   //rotate the bottom of the rc   
  float size=100;//cubies[0].sizeOfC();
  for (int i = 0; i<27; i++) {
    float x, y, z;
    x=cubies[i].position.x;
    y=cubies[i].position.y;
    z=cubies[i].position.z;

    if (i==12) {  //centre blue
      cubies[22].rotateCubeY(angle);
    } else if (cubies[i].position.x==size &&      //top left corner blue 18
      cubies[i].position.y==size &&
      cubies[i].position.z==size) {

      cubies[i].rotateCubeY(angle);
    } else {
      cubies[i].display();
    }
  }
}
void keyReleased() {  //sets b and rPressed back to false when keyreleased
  if (key == 'b' && bPressed == true) { 
    bPressed = false;
  }
  if (key == 'r' && rPressed == true) { 
    rPressed = false;
  }
}
// Custom Cube Class

class Cube {
  // Position, velocity vectors
  PVector position;

  // Vertices of the cube
  PVector[] vertices = new PVector[24];
  // width, height, depth
  float sizeOfCube, x, y, z;

  // colors for faces of cube
 // color[] quadBG = new color[6];
  PImage[] tiles = new PImage[6];


  Cube(float s, int offset) {
    this.sizeOfCube = s;

    
    // Colors are hardcoded
    //quadBG[0] = color(0, 0, 255); //blue
    //quadBG[1] = color(255, 165, 0); //orange
    //quadBG[2] = color(255, 0, 0); //red
    //quadBG[3] = color(0, 128, 0); //green
    //quadBG[4] = color(255, 255, 0); //yellow  bottom
    //quadBG[5] = color(255, 255, 255); // white  
  tiles[2] = loadImage("RED.jpg");
  tiles[2].resize(tiles[2].width/8,tiles[2].height/8);
  tiles[5] = loadImage("White.jpg");
  tiles[0] = loadImage("Solid_blue.svg.png");
  tiles[3] = loadImage("Green.png");
  tiles[1] = loadImage("Orange.png");
  tiles[4] = loadImage("Yellow.png");

    // Start in center
    position = new PVector();
    this.position.x=x;
    this.position.y=y;
    this.position.z=z;
    // Random velocity vector
    // velocity = PVector.random3D();
    // Random rotation
    // rotation = new PVector(random(40, 100), random(40, 100), random(40, 100));

    // cube composed of 6 quads
    //front
    float point = s/2;
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


    if ( offset == 0 )
    { 
      this.position.x=s;
      this.position.y=-s;
      this.position.z=-s;
    }
    if ( offset == 1 )
    { 
      this.position.x=s;
      this.position.y=0;
      this.position.z=-s;
    }
    if ( offset == 2 )
    { 
      this.position.x=s;
      this.position.y=s;
      this.position.z=-s;
    }
    if ( offset == 3 )
    { 
      this.position.x=0;
      this.position.y=-s;
      this.position.z=-s;
    }
    if ( offset == 4 )
    { 
      this.position.x=0;
      this.position.y=0;
      this.position.z=-s;
    }
    if ( offset == 5 )
    { 
      this.position.x=0;
      this.position.y=s;
      this.position.z=-s;
    }
    if ( offset == 6 )
    { 
      this.position.x=-s;
      this.position.y=-s;
      this.position.z=-s;
    }
    if ( offset == 7 )
    { 
      this.position.x=-s;
      this.position.y=0;
      this.position.z=-s;
    }
    if ( offset == 8 )
    { 
      this.position.x=-s;
      this.position.y=s;
      this.position.z=-s;
    }
    if ( offset == 9 )
    { 
      this.position.x=s;
      this.position.y=-s;
      this.position.z=0;
    }
    if ( offset == 10 )
    { 
      this.position.x=s;
      this.position.y=0;
      this.position.z=0;
    }
    if ( offset == 11 )
    { 
      this.position.x=s;
      this.position.y=s;
      this.position.z=0;
    }
    if ( offset == 12 )   //try
    { 
      this.position.x=0;
      this.position.y=-s;
      this.position.z=0;
    }
    if ( offset == 13 )
    { 
      this.position.x=0;
      this.position.y=0;
      this.position.z=0;
    }
    if ( offset == 14 )
    { 
      this.position.x=0;
      this.position.y=s;
      this.position.z=0;
    }
    if ( offset == 15 )
    { 
      this.position.x=-s;
      this.position.y=-s;
      this.position.z=0;
    }
    if ( offset == 16 )
    { 
      this.position.x=-s;
      this.position.y=0;
      this.position.z=0;
    }
    if ( offset == 17 )
    { 
      this.position.x=-s;
      this.position.y=s;
      this.position.z=0;
    }
    if ( offset == 18 )
    { 
      this.position.x=s;
      this.position.y=-s;
      this.position.z=s;
    }
    if ( offset == 19 )
    { 
      this.position.x=s;
      this.position.y=0;
      this.position.z=s;
    }
    if ( offset == 20 )
    { 
      this.position.x=s;
      this.position.y=s;
      this.position.z=s;
    }
    if ( offset == 21 )
    { 
      this.position.x=0;
      this.position.y=-s;
      this.position.z=s;
    }
    if ( offset == 22 )
    { 
      this.position.x=0;
      this.position.y=0;
      this.position.z=s;
    }
    if ( offset == 23 )
    { 
      this.position.x=0;
      this.position.y=s;
      this.position.z=s;
    }
    if ( offset == 24 )
    { 
      this.position.x=-s;
      this.position.y=-s;
      this.position.z=s;
    }
    if ( offset == 25 )
    { 
      this.position.x=-s;
      this.position.y=0;
      this.position.z=s;
    }
    if ( offset == 26 )
    { 
      this.position.x=-s;
      this.position.y=s;
      this.position.z=s;
    }
  } 

  // Cube shape itself
  void drawCube() {
    // Draw cube
    for (int i=0; i<6; i++) {
      fill(150);
      beginShape(QUADS);
       texture(tiles[i]);
      for (int j=0; j<4; j++) {
        vertex(vertices[j+4*i].x, vertices[j+4*i].y, vertices[j+4*i].z);
      }
      endShape();
    }
  }
  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    strokeWeight(13); //outline cubies with a thick line
    drawCube(); // Farm out shape to another method
    popMatrix();
  }
  void rotateCube(float angle1) {

    pushMatrix();
    rotateZ(angle1);
    translate(position.x, position.y, position.z);
    stroke(0); //outline cubies
    drawCube(); // Farm out shape to another method
    popMatrix();
  }
  void rotateCubeY(float angle1) {
      for(float theta = angle1 - PI/2; theta<=angle1; theta+=PI/64){
    pushMatrix();
    rotateY(angle1);
    translate(position.x, position.y, position.z);
    stroke(0); //outline cubies
    drawCube(); // Farm out shape to another method
    popMatrix();
      }
  }
  float sizeOfC () {
    return sizeOfCube;
  }
}