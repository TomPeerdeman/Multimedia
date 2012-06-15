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
 * This file contains an implementation of an RGB color cube
 * The cube consists of smaller cubes that contain RGB values
 * Depending of the amount of cubes the different RGB values are shown in the cube
 * The amount of cubes vary between 2x2x2 up to 16x16x16, this can be changed
 * manually by pressing the UP or DOWN key
 * The space between the cubes can be changed by hand aswell by using
 * the LEFT and RIGHT key
 *
 */


/* Global variables: */
float wBlock = 0.2;

float axisBlocks = 2;

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
  /*
   *
   * key functions:
   * UP    -> increase the number of blocks with 1
   *          with a maximum of 16 blocks
   * DOWN  -> decrease the number of blocks with 1
   *          with a maximum of 2 blocks
   * LEFT  -> decrease the size of a block
   *          smallest value will be shown as a point
   * RIGHT -> increase the size of a block
   *          highest value shows no space between blocks
   *
   */
  
  if (keyPressed) {
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
      if (keyCode == RIGHT && wBlock < (2/axisBlocks)) {
        wBlock += 0.02;
      }
    }
  }

  float disBlocks = 2/axisBlocks - wBlock;
  
  //if the blocks are larger then they should be the size 
  //will be brought down to their maximum value
  if(disBlocks < 0){
    wBlock = 2/axisBlocks;
    disBlocks = 2/axisBlocks - wBlock;
  }
  
  
  //The first translation to center the whole cube as good as possible
  float firstTrans = -.5 - (0.03*(axisBlocks-2));
  translate(firstTrans, firstTrans, -.5);
  
  //Draw the cube
  drawRGBCube(disBlocks, axisBlocks, wBlock);

  // Get original viewBlock matrix:
  popMatrix();
}


/* DrawBlock the color cube */
void drawRGBCube(float disBlocks, float axisBlocks, float wBlock) {
  float yTrans = 0;
  float xTrans = 0;
  float zTrans = 0;

  //Draw each individual cube row by row
  for (int i = 0; i < axisBlocks; i++) {
    if (i > 0) {
      xTrans = xTrans + wBlock + disBlocks;
    }
    for (int j = 0; j < axisBlocks; j++) {
      if (j > 0) {
        yTrans = yTrans + wBlock + disBlocks;
      }
      for (int k = 0; k < axisBlocks; k++) {
        if (k > 0) {
          zTrans = zTrans + wBlock + disBlocks;
        }
        translate(xTrans, yTrans, zTrans);
        fill(xTrans, yTrans, zTrans);
        box(wBlock); // Red
        translate(-xTrans, -yTrans, -zTrans);
      }
      zTrans = 0;
    }
    yTrans = 0;
  }
}
