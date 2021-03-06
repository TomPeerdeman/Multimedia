/*
 * File: Turtle.pde
 *
 *
 * Author: René Aparicio Saez
 * Student nr.: 10214054
 *
 * Author: Tom Peerdeman
 * Student nr.: 10266186
 *
 * Date: 18/06/2012
 *
 */

public class Turtle implements Cloneable{
	private int turtleX;
	private int turtleY;
	private float lineLength;
	private float lineWeight;
	private int angle;
	private int defaultAngle;
	private boolean inPolygon;
	
	private Turtle(float length, int defAngle, float weight, int posX, 
		int posY, int angle){
		lineLength = length;
		lineWeight = weight;
		defaultAngle = defAngle;
		turtleX = posX;
		turtleY = posY; 
		this.angle = angle;
		inPolygon = false;
	}
	
	public Turtle(float length, int angle, float weight){
		lineLength = length;
		lineWeight = weight;
		defaultAngle = angle;
		turtleX = 0;
		turtleY = 0; 
		this.angle = 90;
		inPolygon = false;
	}
	
	public Object clone(){
		// Use the private constructor to make a copy of this object.
		return new Turtle(lineLength, defaultAngle, lineWeight, turtleX, 
			turtleY, angle);
	}
	
	public void turnRight(float angle){
		if(angle == 0f){
			angle = (float) defaultAngle;
		}
		this.angle -= (int) angle;
	}
	
	public void turnLeft(float angle){
		if(angle == 0f){
			angle = (float) defaultAngle;
		}
		this.angle += (int) angle;
	}
	
	public void increase(float ratio){
		if(ratio < 1f){
			return;
		}else if(ratio == 0f){
			ratio = 1.1f;
		}	
		lineLength *= ratio;
		lineWeight *= ratio;
	}
	
	public void decrease(float ratio){
		if(ratio >= 1f){
			return;
		}else if(ratio == 0f){
			ratio = 0.9f;
		}
		lineLength *= ratio;
		lineWeight *= ratio;
	}
	
	public void drawLine(PApplet draw){
		int toY = getEndY();
		int toX = getEndX();
		draw.line(turtleX, turtleY, toX, toY);
		turtleX = toX;
		turtleY = toY;
	}
	
	public void step(){
		turtleX = getEndX();
		turtleY = getEndY();
	}
	
	private int getEndX(){
		return turtleX + 
			(int) Math.round(Math.cos(Math.toRadians(angle)) * lineLength);
	}
	
	private int getEndY(){
		return turtleY + 
			(int) Math.round(Math.sin(Math.toRadians(angle)) * lineLength);
	}
	
	public void update(PApplet draw){
		endP(draw);
		draw.strokeWeight(lineWeight);	
	}
	
	public void beginP(PApplet draw){
		draw.beginShape();
		inPolygon = true;
	}
	
	public void vertexP(PApplet draw){
		if(inPolygon){
			draw.vertex(turtleX, turtleY);
		}
	}
	
	public void endP(PApplet draw){
		if(inPolygon){
			draw.endShape(draw.CLOSE);
			inPolygon = false;
		}
	}
}
