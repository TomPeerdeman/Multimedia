/**
 * Multimedia Practicum-opdracht Color Cube
 *
 * Auteur framewBlockork: Dave van Soest, RvdB
 *
 *
 * Bewerkt door:
 * Tom Peerdeman - 10266186
 * René Aparicio Saez - 10214054
 *
 * Datum: ??/06/2012
 *
 *
 *
 *
 *
 *
 *
 *
 */


/* Global variables: */
float wBlock = 0.5;
float disBlocks = 1;

int axisBlocks = 2;

/* Setup function: */
void setup() {
  size(400, 400, P3D);	// Set output wBlockindowBlock size.
  colorMode(RGB, 1.0);	// Set color mode.
  frameRate(50);        // Set framerate.
  noStroke();		// Don't drawBlock lines.
}


/* DrawBlock function: */
void draw() {
  lights();
  // Make background dark gray:
  background(0.3, 0.3, 0.3);
  
  // Save current viewBlock matrix:
  pushMatrix();

  // Translate histogram into the correct position:
  translate(width/2, height/2, -30);

  // Rotate the histogram depending on the mouse position:
  rotateY(mouseX/float(width) * PI * 4);
  rotateX(mouseY/float(height) * PI * -4);
	
  // DrawBlock the color cube:

  scale(width/4);
  translate(-.5, -.5, -.5);
  if(keyPressed) {
    if (key == CODED) {
      if (keyCode == UP && axisBlocks < 16) {
        axisBlocks += 1;
      }
      if (keyCode == DOWN && axisBlocks > 2) {
        axisBlocks -= 1;
      }
      if (keyCode == LEFT && wBlock > 0.02 ) {
        wBlock -= 0.02;
      }
      /* 
       * chose .98 because of a strange error.
       * If wBlock doesnt start as one from the beginning it will count untill 1.02
       * Hence the choice 0.98
       */
      if (keyCode == RIGHT && wBlock < .98 && (wBlock * axisBlocks) < 2) {
        wBlock += 0.02;
      }
    }
  }
  disBlocks = 1/ (axisBlocks-1);
  drawRGBCube(disBlocks, axisBlocks);

  // Get original viewBlock matrix:
  popMatrix();
}


/* DrawBlock the color cube */
void drawRGBCube(float disBlocks, int axisBlocks) {
  // Your implementation comes here.
  float yTrans = 0;
  float xTrans = 0;
  float zTrans = 0;

  for(int i = 0; i < axisBlocks; i++){
    if(i > 0){
      xTrans = xTrans + wBlock;
    }
    for(int j = 0; j < axisBlocks; j++){
      if(j > 0){
        yTrans = yTrans + wBlock;
      }
      for(int k = 0; k < axisBlocks; k++){
        if(k > 0){
          zTrans = zTrans + wBlock;
        }
        translate(xTrans,yTrans,zTrans);
        fill(xTrans,yTrans,zTrans);
        box(wBlock); // Red
        translate(-xTrans,-yTrans,-zTrans);
      }
      zTrans = 0;
    }
    yTrans = 0;
  }
  
  /*
  fill(0,0,0);
  box(wBlock); // Black 
        
  translate(1,0,0);
  fill(1,0,0);
  box(wBlock); // Red
  
  translate(0,1,0);
  fill(1, 1, 0);
  box(wBlock);
  
  translate(-1, 0, 0);
  fill(0,1,0);
  box(wBlock);
  
  translate(0,0,1);
  fill(0,1,1);
  box(wBlock);
  
  translate(1,0,0);
  fill(1,1,1);
  box(wBlock);
  
  translate(0,-1,0);
  fill(1,0,1);
  box(wBlock);
  
  translate(-1,0,0);
  fill(0,0,1);
  box(wBlock);
  
  */
  
}


