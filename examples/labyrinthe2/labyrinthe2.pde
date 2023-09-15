import R2mix.PScratch.*;
import processing.sound.*;

Chick chick;
Stage stage;
Sounds sounds;

void setup() {
  size(800, 600);

  stage = new Stage(this, "scenes", "session1");
  sounds = new Sounds(stage, "sounds");
  chick = new Chick();
  chick.start();
}

void draw () {
  stage.backdrops();
  stage.pick();                       // pick the color and print it to the console
  chick.draw();
}



void keyPressed() {
  stage.keyIsDown();
}

void keyReleased() {
  stage.keyIsUp();
}
