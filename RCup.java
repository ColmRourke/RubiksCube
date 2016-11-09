
public class RCUp {
	
	static String[][][] possibilities = new String [4][6][9];
	
	public static void main(String args[])
	{
		String [][] colourNames = new String [6][9];
		//red face
//		colourNames[0][0]="b";
//		colourNames[0][1]="y";
//		colourNames[0][2]="y";
//		colourNames[0][3]="g";
//		colourNames[0][4]="r";
//		colourNames[0][5]="b";
//		colourNames[0][6]="r";
//		colourNames[0][7]="b";
//		colourNames[0][8]="g";
//		possibilities[0][0]=colourNames[0];
//
//		//yellow face
//		colourNames[1][0]="o";
//		colourNames[1][1]="r";
//		colourNames[1][2]="r";
//		colourNames[1][3]="r";
//		colourNames[1][4]="y";
//		colourNames[1][5]="w";
//		colourNames[1][6]="y";
//		colourNames[1][7]="o";
//		colourNames[1][8]="g";
//		
//
//		//orange face
//		colourNames[2][0]="y";
//		colourNames[2][1]="g";
//		colourNames[2][2]="r";
//		colourNames[2][3]="b";
//		colourNames[2][4]="o";
//		colourNames[2][5]="r";
//		colourNames[2][6]="o";
//		colourNames[2][7]="o";
//		colourNames[2][8]="g";
//		
//
//		
//		
//		//white face
//		colourNames[3][0]="g";
//		colourNames[3][1]="o";
//		colourNames[3][2]="w";
//		colourNames[3][3]="g";
//		colourNames[3][4]="w";
//		colourNames[3][5]="y";
//		colourNames[3][6]="w";
//		colourNames[3][7]="o";
//		colourNames[3][8]="b";
//		
//
//		//blue face
//		colourNames[4][0]="y";
//		colourNames[4][1]="w";
//		colourNames[4][2]="b";
//		colourNames[4][3]="g";
//		colourNames[4][4]="b";
//		colourNames[4][5]="w";
//		colourNames[4][6]="o";
//		colourNames[4][7]="r";
//		colourNames[4][8]="b";
//		
//
//		
//		//green face
//		colourNames[5][0]="w";          
//		colourNames[5][1]="y";         
//		colourNames[5][2]="r";          
//		colourNames[5][3]="w";          
//		colourNames[5][4]="g";          
//		colourNames[5][5]="b";          
//		colourNames[5][6]="o";         
//		colourNames[5][7]="y";          
//		colourNames[5][8]="w";       
		
		
		colourNames[0][0]="g";
		colourNames[0][1]="r";
		colourNames[0][2]="r";
		colourNames[0][3]="b";
		colourNames[0][4]="r";
		colourNames[0][5]="g";
		colourNames[0][6]="r";
		colourNames[0][7]="b";
		colourNames[0][8]="g";
		possibilities[0][0]=colourNames[0];
		
		colourNames[1][0]="b";
		colourNames[1][1]="r";
		colourNames[1][2]="b";
		colourNames[1][3]="y";
		colourNames[1][4]="y";
		colourNames[1][5]="y";
		colourNames[1][6]="r";
		colourNames[1][7]="w";
		colourNames[1][8]="y";
		
		colourNames[2][0]="o";
		colourNames[2][1]="o";
		colourNames[2][2]="o";
		colourNames[2][3]="r";
		colourNames[2][4]="o";
		colourNames[2][5]="w";
		colourNames[2][6]="b";
		colourNames[2][7]="o";
		colourNames[2][8]="b";
		
		colourNames[3][0]="g";
		colourNames[3][1]="o";
		colourNames[3][2]="y";
		colourNames[3][3]="g";
		colourNames[3][4]="w";
		colourNames[3][5]="o";
		colourNames[3][6]="y";
		colourNames[3][7]="g";
		colourNames[3][8]="w";
		
		colourNames[4][0]="w";
		colourNames[4][1]="g";
		colourNames[4][2]="w";
		colourNames[4][3]="w";
		colourNames[4][4]="b";
		colourNames[4][5]="b";
		colourNames[4][6]="o";
		colourNames[4][7]="w";
		colourNames[4][8]="w";
		
		colourNames[5][0]="g";
		colourNames[5][1]="y";
		colourNames[5][2]="y";
		colourNames[5][3]="r";
		colourNames[5][4]="g";
		colourNames[5][5]="b";
		colourNames[5][6]="r";
		colourNames[5][7]="y";
		colourNames[5][8]="o";
		
		for(int i=0; i<9; i++){
			System.out.print(colourNames[0][i] + "|");
			if(i%3==2)
			System.out.println("");
		}
		
		rotateFace(colourNames);
		check();
	}
	
	
	
	public static void rotateFace (String face[][])
	{

		String[] newFace = new String [9];
		
		for(int twist =0; twist<4; twist++){
			System.out.println("");
			
			for(int faceToRotate = 1; faceToRotate<6; faceToRotate++){

				newFace[2]=face[faceToRotate][0];
				newFace[5]=face[faceToRotate][1];
				newFace[8]=face[faceToRotate][2];
				newFace[1]=face[faceToRotate][3];
				newFace[4]=face[faceToRotate][4];
				newFace[7]=face[faceToRotate][5];
				newFace[0]=face[faceToRotate][6];
				newFace[3]=face[faceToRotate][7];
				newFace[6]=face[faceToRotate][8];

				face[faceToRotate] = newFace;
				possibilities[twist][faceToRotate] = newFace;
				newFace = new String [9];
			}
		}	
		for(int k=0; k<4; k++){
			for(int j=1; j<6; j++){

				for(int i=0; i<9; i++){
					//System.out.print(possibilities[k][j][i] + "|");
					//if(i%3==2)
					//	System.out.println("");
				}
				//System.out.println("");
			}
		}
	}
	
	public static void check (){
		
		String[][] combination= new String [6][9];
		combination[0]=possibilities[0][0];//red
		
		for(int twist0 =0; twist0<4; twist0++ ){
			for(int twist1 =0; twist1<4; twist1++ ){
				for(int twist2 =0; twist2<4; twist2++ ){
					for(int twist3 =0; twist3<4; twist3++ ){
						for(int twist4 =0; twist4<4; twist4++ ){
							
							combination[1]=possibilities[twist0][1]; //yellow
							combination[2]=possibilities[twist1][2]; //orange
							combination[3]=possibilities[twist2][3]; //white 
							combination[4]=possibilities[twist3][4]; //blue
							combination[5]=possibilities[twist4][5]; //green

							////////corners////////////
							String [] cubie = new String[8];
							String [] edges = new String[12];
							//red yellow white
							cubie[0] = combination[0][0] + combination[3][2] + combination[4][6];
							//red yellow blue
							cubie[1] = combination[0][2] + combination[4][8] + combination[1][0];
							//red white green
							cubie[2]= combination[0][6] + combination[3][8] + combination[5][0];
							//red green yellow
							cubie[3]= combination[0][8] + combination[5][2] + combination[1][6];
							//blue orange white
							cubie[4] = combination[4][0] + combination[2][2] + combination[3][0];
							//blue orange yellow
							cubie[5] = combination[4][2] + combination[2][0] + combination[1][2];
							//orange white green
							cubie[6] = combination[2][8] + combination[3][6] + combination[5][6];
							//orange yellow green
							cubie[7] = combination[2][6] + combination[1][8] + combination[5][8];
							
							//edges////////
							//red white
							edges[0]= combination[0][3] + combination[3][5] ;
							//red blue
							edges[1]= combination[0][1] + combination[4][7] ;
							//red yellow
							edges[2]= combination[0][5] + combination[1][3] ;
							//red green
							edges[3]= combination[0][7] + combination[5][7] ;
							//yellow blue
							edges[4]= combination[1][1] + combination[4][5] ;
							//yellow green
							edges[5]= combination[1][7] + combination[5][5] ;
							//white blue
							edges[6]= combination[3][1] + combination[4][3] ;
							//white green
							edges[7]= combination[3][7] + combination[5][3] ;
							//orange blue
							edges[8]= combination[2][1] + combination[4][1] ;
							//orange yellow
							edges[9]= combination[2][3] + combination[1][5] ;
							//orange white
							edges[10]=combination[2][5] + combination[3][3] ;
							//orange green 
							edges[11]= combination[2][7] + combination[5][1] ;

                            boolean pass = true;
							for(int i =0; i<8; i++){
								//System.out.println(cubie[i]);
								for(int j =0; j<3; j++){
									char opp = opposite( cubie[i].charAt(j));
									char one = cubie[i].charAt(0);
									char two = cubie[i].charAt(1);
									char three = cubie[i].charAt(2);
									if(cubie[i].indexOf(opp)>=0 || one==two ||
											two==three|| one==three)
									{
										pass=false;
										//System.out.println("error");
										break;
									}
								}
								
							}
							//System.out.println("");
							for(int i =0; i<12; i++){
								//System.out.println(edges[i]);
								for(int j =0; j<2; j++){
									char opp = opposite( edges[i].charAt(j));
									char one = edges[i].charAt(0);
									char two = edges[i].charAt(1);
									if(edges[i].indexOf(opp)>=0 || one==two)
									{
										pass=false;
										//System.out.println("error");
										break;
									}
								}
							}
							if(pass == true){
								System.out.println("");
								for(int i=0; i<8; i++){
							       System.out.println(cubie[i]);
								}
								//System.out.println(twist1+""+twist2+""+twist3+""+twist4+"");
								for(int j=0; j<12; j++)
								{
									System.out.println(edges[j]);
								}
								System.out.println("");
							}
						}
					}
				}
			}
		}
		
		
	}
	public static char opposite(char p){
		
		if(p=='r'){
			return 'o';
		}
		else if(p=='o')
			return 'r';
		
		else if(p=='g')
			return 'b';
		
		else if(p=='b')
			return 'g';
		
		else if(p=='w')
			return 'y';
		
		else 
			return 'w';
		
		
		
	}
}
