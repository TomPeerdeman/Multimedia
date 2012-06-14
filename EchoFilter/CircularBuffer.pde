/*
 * File: CircularBuffer.pde
 *
 * This file contains an implementation of a float circular buffer.
 * The buffer is dynamic: when the buffer is full it will enlarge itself.
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

class CircularBuffer{
  float[] buffer;
  float[] bufferResize;
  int head;
  int tail;
  int fill;
  
  CircularBuffer(int initCap){
    head = 0;
    tail = 0;
    fill = 0;
    buffer = new float[initCap];
  }
  
  boolean addSample(float v){
      if(fill == buffer.length){
        bufferResize = new float[buffer.length * 2];
        if(head == 0){
          arraycopy(buffer, 0, bufferResize, 0, buffer.length);       
        }else{
          arraycopy(buffer, tail, bufferResize, 0, buffer.length - tail);
          arraycopy(buffer, 0, bufferResize, buffer.length - tail, head);
        }
        head = buffer.length;
        tail = 0;
        buffer = bufferResize;
        bufferResize = null;
      }
      
      buffer[head++] = v;
      fill++;
      head %= buffer.length;
      return true;
  }
  
  float getSample(){
     if(fill == 0){
      return 0f;
     } 
     
     float get = buffer[tail++];
     tail %= buffer.length;
     fill--;
     return get;
  }
  
  void clear(){
   tail = 0;
   head = 0; 
   fill = 0;
  }
}
