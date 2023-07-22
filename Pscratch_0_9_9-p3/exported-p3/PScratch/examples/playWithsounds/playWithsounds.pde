import processing.sound.*;
import R2mix.PScratch.*;

Instruments drum, guitar;
Stage stage;
Sounds sounds;

void setup() {
  size(800, 600);
  stage = new Stage(this, "scenes");
  // loadSounds into soundsFolder (can be renamed)
  sounds = new Sounds(stage, "sounds");
  drum= new Instruments(200, 200, 1);
  guitar= new Instruments(600, 200, 0);
}

void draw () {
  stage.backdrops();
  drum.draw();
  guitar.draw();
}

void mousePressed() {
  stage.pick();
  drum.mousePressed(1);
  guitar.mousePressed(0);
}
