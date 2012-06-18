/*
 * File: LindenmayerDraw.pde
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

import processing.opengl.*;
import java.util.LinkedList;

private Turtle turtle;
private StringBuffer str;
private LinkedList<TurtleAction> actions;
private LinkedList<Turtle> stack;
private int nDraw;

public void setup(){
	size(400, 400, OPENGL);
	// Use low framerate, the drawn image will be constant anyway.
	frameRate(1);

	loadLSystem("plant.lsys");
}

public void drawLString(String lstr, float length, int angle, float thickness){	
	str = new StringBuffer(lstr);
	turtle = new Turtle(length, angle, thickness);
	actions = new LinkedList<TurtleAction> ();
	stack = new LinkedList<Turtle> ();
	nDraw = 1;
	
	// Loop trough chars, insert actions in linkedlist
	for(int i = 0; i < str.length(); i++){
		switch(str.charAt(i)){
			case 'f':
				actions.addFirst(new TurtleAction(TurtleAction.STEP));
				break;
			case 'F':
				actions.addFirst(new TurtleAction(TurtleAction.STEPDRAW));
				break;
			case '+':
				actions.addFirst(new TurtleAction(TurtleAction.TURNLEFT));
				break;
			case '-':
				actions.addFirst(new TurtleAction(TurtleAction.TURNRIGHT));
				break;	
			case '\'':
				actions.addFirst(new TurtleAction(TurtleAction.INCREASE));
				break;	
			case '\"':
				actions.addFirst(new TurtleAction(TurtleAction.DECREASE));
				break;
			case '[':
				actions.addFirst(new TurtleAction(TurtleAction.PUSH));
				break;				
			case ']':
				actions.addFirst(new TurtleAction(TurtleAction.POP));
				break;	
			case '{':
				actions.addFirst(new TurtleAction(TurtleAction.PUSH));
				actions.addFirst(new TurtleAction(TurtleAction.BEGINP));
				break;	
			case '.':
				actions.addFirst(new TurtleAction(TurtleAction.VERTEXP));
				break;
			case '}':
				actions.addFirst(new TurtleAction(TurtleAction.ENDP));
				actions.addFirst(new TurtleAction(TurtleAction.POP));
				break;	
			case '(':
				if(str.indexOf(")", i) > 0){
					String parse = str.substring(i + 1, str.indexOf(")", i));
					i += parse.length() + 1;
					if(actions.size() > 0){
						actions.getFirst().setParam(Float.parseFloat(parse));
					}
				}
		}
	}
}

public void setNDraw(int n){
	nDraw = n;
}

public void draw(){
	background(0xFFFFFFFF);
	
	if(actions != null && actions.size() > 0){
		// Update turtle to set the line weight
		turtle.update(this);
		
		if(stack.size() == 0){
			// Push the initial state
			pushTurtle();
		}else{
			// Push the initial state, the current state may be different
			restoreTurtle();
		}
		
		// Translate to normal coordinate system
		translate(200, 400);
		rotateZ(PI);
		scale(-1, 1);
		
		// Set line color to black
		stroke(0, 0, 0, 255);
		
		for(int j = 0; j < nDraw; j++){
			for(int i = 0; i < actions.size(); i++){
				TurtleAction action = actions.removeLast();
				switch(action.getAction()){
					case TurtleAction.STEP:
						turtle.step();
						break;
					case TurtleAction.STEPDRAW:
						turtle.drawLine(this);
						break;
					case TurtleAction.TURNLEFT:
						turtle.turnLeft(action.getParam());
						break;
					case TurtleAction.TURNRIGHT:
						turtle.turnRight(action.getParam());
						break;
					case TurtleAction.INCREASE:
						turtle.increase(action.getParam());
						turtle.update(this);
						break;
					case TurtleAction.DECREASE:
						turtle.decrease(action.getParam());
						turtle.update(this);
						break;
					case TurtleAction.PUSH:
						pushTurtle();
						break;
					case TurtleAction.POP:
						popTurtle();
						turtle.update(this);
						break;
					case TurtleAction.BEGINP:
						turtle.beginP(this);
						break;
					case TurtleAction.VERTEXP:
						turtle.vertexP(this);
						break;
					case TurtleAction.ENDP:
						turtle.endP(this);
				}
				// Push the action back into the queue
				actions.addFirst(action);
			}
		}
	}
}

private void pushTurtle(){
	stack.addFirst((Turtle) turtle.clone());
}

private void popTurtle(){
	if(stack.size() > 0){
		turtle = stack.removeFirst();
	}
}

private void restoreTurtle(){
	if(stack.size() > 0){
		// Clone so we dont edit the stack copy each time.
		turtle = (Turtle) stack.getLast().clone();
	}
}

private void loadLSystem(String filePath){
	String[] lines = loadStrings(filePath);
	
	if(lines.length < 8){
		System.out.println("File parse error: expected at least 8 lines found "
			+ lines.length);
		return;
	}
	
	// Parse constants
	int angle = Integer.parseInt(lines[0]);
	float length = Float.parseFloat(lines[1]);
	float weight = Float.parseFloat(lines[2]);
	int nDraw = Integer.parseInt(lines[3]);
	int nApply = Integer.parseInt(lines[4]);
	
	if(lines[5].length() != 0){
		System.out.println("File parse error: expected newline found "
			+ lines[5]);
		return;
	}
	
	LSystem lsys = new LSystem();
	
	// Parse rules
	int idx = 6;
	while(lines[idx].length() != 0){
		String[] split = split(lines[idx], "->");
		lsys.addRule(split[0].charAt(0), split[1]);
		idx++;
		if(idx >= lines.length){
			System.out.println("File parse error: expected newline found "
				+ lines[--idx]);
			return;
		}
	}
	
	if(++idx >= lines.length){
		System.out.println("File parse error: expected axiom found end");
		return;
	}
	
	lsys.setAxiom(lines[idx]);
	
	// Draw the LSystem
	drawLString(lsys.applyRules(nApply), length, angle, weight);
	setNDraw(nDraw);
}