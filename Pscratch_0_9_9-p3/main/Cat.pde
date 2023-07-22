class Cat extends Sprite {           // create the sprite instance named "Cat"

  Cat() {
    super(stage, "cat");             // look into sprite folder and import image, each sprite MUST have its own folder named
  }

  void draw() {                      // call it into the main draw void or just call sprite.display into main draw void
   display();                        // for showing and using the sprite, better call it in last
  }

  void run() {                       // thread where you can code without screen frameRate
  }
}
