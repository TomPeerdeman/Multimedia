/*
 * File: EchoFilter.pde
 *
 * This file contains the setup method wich starts the audioplayer with the 
 * echo effect enabled.
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


import ddf.minim.*;
import ddf.minim.effects.*;
import processing.opengl.*;

Minim minim;
AudioPlayer player;
EchoEffect effect;
ScrollBar delayBar;
ScrollBar volumeBar;
float delayPos;
float volumePos;

void setup(){
  size(200, 100, OPENGL);
  volumeBar = new ScrollBar(50, 20, 110, 10, 5);
  delayBar = new ScrollBar(50, 60, 110, 10, 5);
  
  minim = new Minim(this);
  player = minim.loadFile("groove.mp3", 1024);
  effect = new EchoEffect();
  player.addEffect(effect);
  player.loop();
}

void draw(){
    background(0);
    // Set text color
    fill(0xFF, 0xFF, 0xFF);
    text("Echo volume ratio: " + floor((volumeBar.getPos() - 50)) / 100f, 50, 40);
    text("Delay: " + floor((delayBar.getPos() - 50)) / 10f, 50, 80);
    
    volumeBar.update();
    delayBar.update();
    volumeBar.display();
    delayBar.display();
    
    // Only update the effect if the value of one of the bars has changed.
    if(volumePos != volumeBar.getPos()){
      volumePos = volumeBar.getPos();
      effect.setEchoVolume(floor((volumePos - 50)) / 100f);
    }
    if(delayPos != delayBar.getPos()){
      delayPos = delayBar.getPos();
      effect.setDelay(floor((delayPos - 50)) / 10f);
    }
}

void stop(){
  player.close();
  minim.stop();
  super.stop();
}
