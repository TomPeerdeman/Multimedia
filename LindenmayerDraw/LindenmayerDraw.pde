import processing.opengl.*;
import java.util.LinkedList;

private Turtle turtle;
private StringBuffer str;
private LinkedList<TurtleAction> actions;
private LinkedList<Turtle> stack;

public void setup(){
	size(400, 400, OPENGL);
	drawLString("+\"(0.5)f'(2)-F-F-F-F[-ffF-F-F-F][f-f\"(0.5)f'(2)-(45)F-F-F-F]--ff+f\"(0.5)f'(2)+(135)F-F-F-F", 100f, 90, 2);
}

public void drawLString(String lstr, float length, int angle, float thickness){	
	str = new StringBuffer(lstr);
	turtle = new Turtle(length, angle, thickness);
	actions = new LinkedList<TurtleAction> ();
	stack = new LinkedList<Turtle> ();
	
	// Loop trough chars, insert Actions in linkedlist
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
				actions.addFirst(new TurtleAction(TurtleAction.BEGINP));
				break;				
			case '}':
				actions.addFirst(new TurtleAction(TurtleAction.ENDP));
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
		translate(200, 350);
		rotateZ(PI);
		scale(-1, 1);
		
		// Set line color to black
		stroke(0, 0, 0, 255);
		
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
			}
			actions.addFirst(action);
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
		// Clone so we dont edit the stack copy each time. Always the last one.
		turtle = (Turtle) stack.getLast().clone();
	}
}