Cat cat;                        // create a new sprite
Stage stage;                     // create the scene
Sounds sounds;

void setup() {                   // --- when program starts (like green flag)
  size(800,600);                // screen size
  stage = new Stage(this,"stage");    // initialize the scene
  sounds = new Sounds(stage, "sounds");         // loadSounds into soundsFolder (can be renamed)
  //-----initialize sprites-----------
  cat= new Cat();
  //-----launch all run thread after initialize all sprites-----------
  cat. start();                  // launch thread run, independent from draw
}                                // ------end of starting program ------

void draw () {                   //-----forever at 60 fps-----
  stage.backdrops();             // display the backdrops of the scene
  cat.draw();                    // display a sprite can be also cat.display
}   //----end of draw -----

void mousePressed(){
  stage.pick();
}

void keyPressed() {              // called when a key is pressed
  stage.keyIsDown();                   // check if all keys are pressed or not
}

void keyReleased() {             // called when a key is released
  stage.keyIsUp();                     // check if all keys are released or not
}
