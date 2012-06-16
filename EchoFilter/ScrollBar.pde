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
 * Date: 16/06/2012
 *
 */

public class ScrollBar{
	private int swidth, sheight;		// width and height of bar
	private int xpos, ypos;				// x and y position of bar
	private float spos, newspos;		// x position of slider
	private int sposMin, sposMax;		// max and min values of slider
	private int loose;					// how loose/heavy
	private boolean over;				// is the mouse over the slider?
	private boolean locked;

	public ScrollBar(int xp, int yp, int sw, int sh, int l){
		swidth = sw;
		sheight = sh;
		int widthtoheight = sw - sh;
		xpos = xp;
		ypos = yp-sheight/2;
		spos = xpos + swidth/2 - sheight/2;
		newspos = spos;
		sposMin = xpos;
		sposMax = xpos + swidth - sheight;
		loose = l;
	}

	public void update(){
		if(over()){
			over = true;
		}else{
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

	private int constrain(int val, int minv, int maxv){
		return min(max(val, minv), maxv);
	}

	private boolean over() {
		if(mouseX > xpos && mouseX < xpos+swidth
			&& mouseY > ypos && mouseY < ypos+sheight){
			return true;
		}else{
			return false;
		}
	}

	public void display(){
		fill(255);
		rect(xpos, ypos, swidth, sheight);
		if(over || locked){
			fill(153, 102, 0);
		}else{
			fill(102, 102, 102);
		}
		rect(spos, ypos, sheight, sheight);
	}

	public float getPos(){
		return spos;
	}
}
