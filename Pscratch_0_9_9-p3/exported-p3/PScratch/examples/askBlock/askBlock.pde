import processing.sound.*;
import R2mix.PScratch.*;


Cat cat;
Stage stage;
Sounds sounds;

void setup() {
  size(800, 600);
  stage = new Stage(this, "scenes");
  sounds =new Sounds(stage, "sounds");
  cat= new Cat();
  cat.start();
}

void draw () {
  stage.backdrops();
  cat.draw();
}


void keyPressed() {              // called when a key is pressed
  stage.keyIsDown();                   // check if all keys are pressed or not
}

void keyReleased() {             // called when a key is released
  stage.keyIsUp();                     // check if all keys are released or not
}
