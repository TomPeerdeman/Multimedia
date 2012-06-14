import ddf.minim.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer player;
EchoEffect effect;

void setup(){
  size(200, 200, P2D);
  
  minim = new Minim(this);
  player = minim.loadFile("groove.mp3", 1024);
  effect = new EchoEffect(1024);
  player.addEffect(effect);
  player.loop();
}

void stop(){
  player.close();
  minim.stop();
  super.stop();
}
