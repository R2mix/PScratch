Cat cat;                        // create a new sprite
Stage stage;                     // create the scene                        

void setup() {                   // --- when program starts (like green flag)
  size(800, 600);                // screen size
  stage = new Stage("scenes");   // initialize the scene
  soundFolder("sounds");         // loadSounds into soundsFolder (can be renamed)
  //-----initialize sprites-----------
  cat= new Cat();    
}                                // ------end of starting program ------

void draw () {                   //-----forever at 60 fps-----
  stage.backdrops();             // display the backdrops of the scene
  pickColor();
  cat.draw();                    // display a sprite can be also cat.display
}                                //----end of draw -----


void keyPressed() {              // called when a key is pressed
  keyIsDown();                   // check if all keys are pressed or not
}

void keyReleased() {             // called when a key is released
  keyIsUp();                     // check if all keys are released or not
}
