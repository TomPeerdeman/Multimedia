/**
 * User Defined Effect 
 * by Damien Di Fede.
 *  
 * This sketch demonstrates how to write your own AudioEffect. 
 * See NoiseEffect.pde for the implementation.
 */

import ddf.minim.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer player;
EchoEffect effect;

void setup()
{
  size(512, 200, P2D);
  
  minim = new Minim(this);
  player = minim.loadFile("groove.mp3", 1024);
  effect = new EchoEffect();
  player.addEffect(effect);
  player.play();
}

void draw()
{
  
}

void stop()
{
  // always close Minim audio classes when you finish with them
  player.close();
  // always stop Minim before exiting
  minim.stop();

  super.stop();
}
