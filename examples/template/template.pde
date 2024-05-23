/**
 PScratch by R2mix
 For documentation : https://github.com/r2mix/pscratch
 */

import R2mix.PScratch.*;
import processing.sound.*;

Cat cat;
Stage stage;
Sounds sounds;

void setup() {
  size(800, 600);
  stage = new Stage(this, "scenes");
  sounds = new Sounds(stage, "sounds");
  cat= new Cat();
  cat.start();
}
void draw () {
  stage.backdrops();
  cat.draw();
}
void mousePressed() {             // called when the mouse is pressed
  stage.pick();                  // Print the value of the color on the mouse position, the mouse cordonates, the size of the screen, the frameRate
}
void keyPressed() {              // called when a key is pressed
  stage.keyIsDown();             // check if all keys are pressed or not
}
void keyReleased() {             // called when a key is released
  stage.keyIsUp();               // check if all keys are released or not
}
