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
int axisBlocks = 2;

PImage RGBImage;
int[] RGBHist = new int[4096];
int histMax = 0;

/* Setup function: */
void setup() {
  size(400, 800, P3D);	// Set output wBlockindowBlock size.
  colorMode(RGB, 1.0);	// Set color mode.
  frameRate(50);        // Set framerate.
  noStroke();		// Don't drawBlock lines.
  
  
  RGBImage = loadImage("oranje.jpg"); //load the image
  buildHistogram();
}


/* DrawBlock function: */
void draw() {
  lights();
  // Make background dark gray:
  background(0.3, 0.3, 0.3);

  image(RGBImage, 200 - RGBImage.width / 2, 600 - RGBImage.height / 2);
  // Save current viewBlock matrix:
  pushMatrix();

  // Translate histogram into the correct position:
  translate(width/2, height/4, -30);

  // Rotate the histogram depending on the mouse position:
  rotateY(mouseX/float(width) * PI * 4);
  rotateX(mouseY/float(height) * PI * -4);

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
        buildHistogram();
      }
      if (keyCode == DOWN && axisBlocks > 2) {
        axisBlocks -= 1;
        buildHistogram();
      }
      if (keyCode == LEFT && wBlock > 0.04 ) {
        wBlock -= 0.02;
      }
      if (keyCode == RIGHT && wBlock < 1) {
        wBlock += 0.02;
      }
    }
  }

  float disBlocks = 2/ ((float)axisBlocks) - wBlock;
  
  //if the blocks are larger then they should be the size 
  //will be brought down to their maximum value
  if(disBlocks < 0){
    disBlocks = 2/((float)axisBlocks) - wBlock;
  }
  
  
  //centering the cube
  float Centre = (float) -(axisBlocks-1) /2;
  scale((float) width / (2 + 2 * axisBlocks));
  translate(Centre , Centre, Centre);
 
  //Draw the RGB cube of the image
  drawRGBCube(disBlocks, axisBlocks, wBlock);

  // Get original viewBlock matrix:
  popMatrix();
}


/* DrawBlock the color cube */
void drawRGBCube(float disBlocks, int axisBlocks, float wBlock) {
  //Draw each individual cube containing the value of that color in the image
  for (int i = 0; i < axisBlocks; i++) {
    for (int j = 0; j < axisBlocks; j++) {
      for (int k = 0; k < axisBlocks; k++) {
        fill((float) k / axisBlocks, (float) j / axisBlocks, (float) i / axisBlocks);
        box(wBlock * RGBHist[axisBlocks * axisBlocks * i + axisBlocks * j + k]/histMax);
        translate(1, 0, 0);
      }
      translate(-axisBlocks, 1, 0);
    }
    translate(0, -axisBlocks, 1);
  }
}

// Filling the histogram array
void buildHistogram(){
  for (int i = 0; i < 4096; i++){
    RGBHist[i] = 0;
  }
  histMax = 0;
  int RGBcolor, n, histRed, histGreen, histBlue;
  
  RGBImage.loadPixels();
  
  for (int i = 0; i < RGBImage.height; i++){
    for (int j = 0; j < RGBImage.width; j++){
      RGBcolor = RGBImage.pixels[RGBImage.width * i + j];
      histRed =  (int)(red(RGBcolor) * axisBlocks);
      histGreen =  (int)(green(RGBcolor) * axisBlocks);
      histBlue =  (int)(blue(RGBcolor) * axisBlocks);
      if (histRed == axisBlocks)
        histRed = axisBlocks - 1;
      if (histGreen == axisBlocks)
        histGreen = axisBlocks - 1;
      if (histBlue == axisBlocks)
        histBlue = axisBlocks - 1;
      n = (int) (axisBlocks*axisBlocks*histBlue + axisBlocks*histGreen + histRed);
      RGBHist[n]++;
      
      //The maximum value should be remembered to ensure blocks wont overlap
      if (RGBHist[n] > histMax)
        histMax = RGBHist[n];
    }
  }
}
