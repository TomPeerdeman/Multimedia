class EchoEffect implements AudioEffect{
  CircularBuffer bufLeft;
  CircularBuffer bufRight;
  int delayLength;
  float echoVolume;
  float nonEchoVolume;
  
  EchoEffect(int bufLeng){
   setDelay(0.2f);
   setEchoVolume(0.3f);
   
   System.out.printf("Delay of %d\n", delayLength);
   System.out.printf("Echo volume ratio %f\n", echoVolume);
   bufLeft =  new CircularBuffer(delayLength + 1);
   bufRight =  new CircularBuffer(delayLength + 1);
  }
  
  void setDelay(float delay){
    delayLength = (int) (44100 * delay);
  }
  
  void setEchoVolume(float vol){
    echoVolume = vol;
    nonEchoVolume = 1f - vol;
  }
   
  void process(float[] samp){
    for(int i = 0; i < samp.length; i++){
        bufLeft.addSample(samp[i]);
        if(bufLeft.fill >= delayLength){
          samp[i] = samp[i] * nonEchoVolume;
          samp[i] += bufLeft.getSample() * echoVolume;
        }
    }
  }
   
  void process(float[] left, float[] right){
    for(int i = 0; i < left.length; i++){
        bufLeft.addSample(left[i]);
        bufRight.addSample(right[i]);
        if(bufLeft.fill >= delayLength){
          left[i] = left[i] * nonEchoVolume;
          left[i] += bufLeft.getSample() * echoVolume;
          right[i] = right[i] * nonEchoVolume;
          right[i] += bufRight.getSample() * echoVolume;
        }
    }
  }
}
  
