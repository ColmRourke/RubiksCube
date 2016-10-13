
import processing.opengl.*;

Cube[] cubies = new Cube[27]; 
float angle =0;
boolean bPressed = false;
void setup() {
  size(600, 600, OPENGL);
  int id=0;
  for (int z = -1; z<=1; z++){
 
  for (int x = -1; x<=1; x++){
  
       for (int y = -1; y<=1; y++)
       
          {
           cubies[id] = new Cube (100,x,y,z,1,1,1);
           id++;  
        }
     }
  }
  
}
//
void draw() {
  background(0);
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

  }
  for(Cube c: cubies){
    c.display();
  }
}
void backRotate() {
  float size=100;//cubies[0].sizeOfC();
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

void keyReleased() {  //sets b and rPressed back to false when keyreleased
  if (key == 'b' && bPressed == true) { 
    bPressed = false;
  }
}
// Custom Cube Class

class Cube {
  // Position, velocity vectors
  PVector position;
  // Vertices of the cube
  PVector[] vertices = new PVector[24];
  // width, height, depth
  int sizeOfCube, x, y, z;
  int cx,cy,cz;//color
  int dx,dy,dz; //colour direction, d= -1 or 1 or 0 if no color on that direction
  // colors for faces of cube
  color[] quadBG = new color[7];

  Cube(int s, int x,int y,int z,int cx,int cy, int cz) {
    this.sizeOfCube = s;

    // Colors are hardcoded
    quadBG[0] = color(0, 0, 255); //blue           z
    quadBG[1] = color(255, 165, 0); //orange       x
    quadBG[2] = color(255, 0, 0); //red            x
    quadBG[3] = color(0, 128, 0); //green          z
    quadBG[4] = color(255, 255, 0); //yellow  bottom y
    quadBG[5] = color(255, 255, 255); // white     y
 
    
    

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
}