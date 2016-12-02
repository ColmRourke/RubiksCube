import processing.opengl.*;

String [][] colourNames = {
        {"w","r","r","b","r","b","w","g","b"},
        {"b","y","g","r","y","w","y","g","y"},
        {"y","y","y","r","o","o","b","w","g"},
        {"g","g","r","b","w","w","o","y","b"},
        {"o","r","r","o","b","o","g","g","w"},
        {"o","w","r","b","g","y","w","o","o"}};
Cube [] cubies = new Cube[27];

void setup() {
  size(600, 600, OPENGL);
  cubies=getRc();
}

void draw() {
  background(50);
  lights();
  stroke(0);
  translate(width/2, height/2);
  rotateX(-mouseY*0.01);
  rotateY(mouseX*-0.01);
  
  for(int i =0; i<27; i++){
    cubies[i].display();
  }
}

void keyPressed() {
  if (key == 'f') 
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
