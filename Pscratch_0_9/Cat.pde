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
