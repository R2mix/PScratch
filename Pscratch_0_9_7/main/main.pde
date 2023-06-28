Cat cat;                        // create a new sprite
Stage stage;                     // create the scene

void setup() {                   // --- when program starts (like green flag)
  size(1000,600);                // screen size
  printFolder();
  stage = new Stage("stage");   // initialize the scene
  soundFolder("sounds");         // loadSounds into soundsFolder (can be renamed)
  //-----initialize sprites-----------
  cat= new Cat();
  //-----launch all run thread after initialize all sprites-----------
  cat. start();                  // launch thread run, independent from draw
}                                // ------end of starting program ------

void draw () {                   //-----forever at 60 fps-----
  stage.backdrops();             // display the backdrops of the scene
  pick();
  cat.draw();                    // display a sprite can be also cat.display
  println(frameRate);
}                                //----end of draw -----


void keyPressed() {              // called when a key is pressed
  keyIsDown();                   // check if all keys are pressed or not
}

void keyReleased() {             // called when a key is released
  keyIsUp();                     // check if all keys are released or not
}
