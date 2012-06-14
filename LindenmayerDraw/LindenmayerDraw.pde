import processing.opengl.*;
import java.util.LinkedList;

private Turtle turtle;
private StringBuffer str;
private boolean clear;
private int strIdx;
private LinkedList<TurtleAction> actions;

void setup(){
 size(400, 400, OPENGL);
 translate( 200, 400 );
 rotateZ( PI );
 scale(1);  
 clear = true;
}

public void drawLString(String lstr, float length, int angle, float thickness){
  clear = true;
  str = new StringBuffer(lstr);
  strIdx = 0;
  turtle = new Turtle(length, angle, thickness);
  actions = new LinkedList<TurtleAction> ();
  
  // Loop trough chars, insert Actions in linkedlist
}

void draw(){
  if(clear){
     clear = false;
     background(0xFF); 
  }
  

}

void drawLine(){
  //Drawline method
  //Using asin/acos?
}

