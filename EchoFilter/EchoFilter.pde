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

Minim minim;
AudioPlayer player;
EchoEffect effect;

void setup(){
  size(200, 200, P2D);
  
  minim = new Minim(this);
  player = minim.loadFile("groove.mp3", 1024);
  effect = new EchoEffect();
  player.addEffect(effect);
  player.loop();
}

void stop(){
  player.close();
  minim.stop();
  super.stop();
}
