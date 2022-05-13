# PScratch-lib-0.8.1

PScratch is a package for processing that give the possibility to use basic scratch function for learning processing

#### Initialization
For start (in futur this will be an importable library), you have ton download PScratch released and use the folling code for starting

```java
Cat cat;                         // create a new sprite
Scene scene;                     // create the scene                         // create a new sprite
void setup() {                   // --- when program starts (like green flag)
  size(800, 600);                // screen size
  scene = new Scene("scenes");   // initialize the scene
  soundFolder("sounds");         // loadSounds into soundsFolder (can be renamed)
  //-----initialize sprites-----------
  cat= new Cat();
}                                // ------end of starting program ------
void draw () {                   //-----forever at 60 fps-----
  scene.backdrops();             // display the backdrops of the scene
  pickColor();
  cat.draw();                    // display a sprite can be also cat.display
}                                //----end of draw -----
void keyPressed() {              // called when a key is pressed
  keyIsDown();                   // check if all keys are pressed or not
}
void keyReleased() {             // called when a key is released
  keyIsUp();                     // check if all keys are released or not
}

class Cat extends Sprite {           // create the sprite instance named "Cat"
  Cat() {
    super();                         //call sprite functions
    start();                         // launch thread run, independent from draw
    spriteFolder("cat");             // look into sprite folder and import image, each sprite MSUT have its own folder named
  }
  void draw() {                      // call it into the main draw void or just call sprite.display into main draw void
    display();                       // for showing and using the sprite
  }
  void run() {                       // thread where you can code without screen frameRate
  }
}
```


