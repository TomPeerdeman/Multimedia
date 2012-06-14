public class Turtle{
  public int turtleX;
  public int turtleY;
  public float lineLength;
  public float lineWeight;
  private int defaultAngle;
  
  public Turtle(float length, int angle, float weight){
    lineLength = length;
    lineWeight = weight;
    defaultAngle = angle;
    turtleX = 0;
    turtleY = 0; 
  }
}
