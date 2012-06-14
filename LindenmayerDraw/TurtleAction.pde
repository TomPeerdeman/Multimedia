public class TurtleAction{
  public final static int STEP = 0;
  public final static int STEPDRAW = 1;
  public final static int TURNLEFT = 2;
  public final static int TURNRIGHT = 3;
  public final static int INCREASE = 4;
  public final static int DECREASE = 5;
  public final static int PUSH = 6;
  public final static int POP = 7;
  public final static int BEGINP = 8;
  public final static int ENDP = 9;
  
  private int action;
  private float param;
  
  public TurtleAction(int a, float p){
    action = a;
    param = p;
  }
  
  public int getAction(){
    return action;
  }
  
  public float getParam(){
    return param; 
  }
}
