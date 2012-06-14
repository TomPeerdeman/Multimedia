void setup(){
  CircularBuffer buf = new CircularBuffer(1024);
  int size = (int) random(5120, 20480);
  System.out.printf("Fill up to %d\n", size);
  
  // Fill all
  boolean add = true;
  int n = 0;
  for(int i = 0; add && i < size; i++){
     add = buf.addSample((float) i); 
     if(add)n++;
  }
  
  System.out.printf("Added %d; fill: %d; first: %f; fill after get: %d\n", n, buf.fill, buf.getSample(), buf.fill);
  buf.addSample((float) n);
  System.out.printf("Add 1 (val: %d); fill: % d\n", n, buf.fill);
  
  // Remove all
  n = 0;
  add = true;
  float g;
  for(int i = 0; add && i < size * 2; i++){
    g = buf.getSample();
    add = g != 0;
    if(add && (int) g != n + 1){
       System.out.printf("Chain fail: %d: %f/%d\n", i, g, (n + 1));
       add = false; 
    }
    
    if(add)n++;
  }
  System.out.printf("Removed %d; fill: %d\n", n, buf.fill);
  buf.clear();
  
  
  // Overflow test: add buflength / 2
  add = true;
  n = 0;
  for(int i = 0; add && i < buf.buffer.length / 2; i++){
     add = buf.addSample((float) (i + 1)); 
     if(add)n++;
  }
  System.out.printf("Overflow test: added %d\n", n);
  
  // Remove all
  int j = 0;
  for(int i = 0; add; i++){
    g = buf.getSample();
    add = g != 0;
    if(add && (int) g != j + 1){
       System.out.printf("Chain fail: %d: %f/%d\n", i, g, (j + 1));
       add = false; 
    }
    
    if(add)j++;
  }
  
  System.out.printf("Overflow test: removed %d\n", j);
  
  
  // Fill all (Note: head is not at 0)
  add = true;
  int to = buf.buffer.length + (j * 2);
  for(int i = n; add && i < to; i++){
     add = buf.addSample((float) (i + 1)); 
     if(add)n++;
  }
  System.out.printf("Overflow test: added to %d\n", n);
  
  // Remove all
  
  j = 0;
  for(int i = 0; add; i++){
    g = buf.getSample();
    add = g != 0;
    
    if(add)j++;
  }
  
  System.out.printf("Overflow test: removed %d; fill: %d\n", j, buf.fill);
}


