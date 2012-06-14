// this is a really straightforward effect that just reverses the order of the samples it receives
// it doesn't sound like how you think ;-)
class EchoEffect implements AudioEffect
{
  void process(float[] samp)
  {
    
  }
  
  void process(float[] left, float[] right)
  {
    process(left);
    process(right);
  }
}
  
