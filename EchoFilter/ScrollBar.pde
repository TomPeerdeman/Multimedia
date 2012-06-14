/*
 * File: ScrollBar.pde
 *
 * Source: Processing Examples. Example 'Scrollbar' in category GUI in category Topics
 * Look up date: 14/06/2012
 *
 * Author: René Aparicio Saez
 * Student nr.: 10214054
 *
 * Author: Tom Peerdeman
 * Student nr.: 10266186
 *
 * Date: 14/06/2012
 *
 */

class ScrollBar{
  int swidth, sheight;    // width and height of bar
  int xpos, ypos;         // x and y position of bar
  float spos, newspos;    // x position of slider
  int sposMin, sposMax;   // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  ScrollBar (int xp, int yp, int sw, int sh, int l){
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    ratio = 1;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update(){
    if(over()) {
      over = true;
    } else {
      over = false;
    }
    if(mousePressed && over){
      locked = true;
    }
    if(!mousePressed){
      locked = false;
    }
    if(locked){
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if(abs(newspos - spos) > 1){
      spos = spos + (newspos-spos)/loose;
    }
  }

  int constrain(int val, int minv, int maxv){
    return min(max(val, minv), maxv);
  }

  boolean over() {
    if(mouseX > xpos && mouseX < xpos+swidth &&
    mouseY > ypos && mouseY < ypos+sheight){
      return true;
    } else {
      return false;
    }
  }

  void display(){
    fill(255);
    rect(xpos, ypos, swidth, sheight);
    if(over || locked) {
      fill(153, 102, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos(){
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos;
  }
}
