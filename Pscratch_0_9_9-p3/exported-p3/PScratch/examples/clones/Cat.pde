class Cat extends Sprite {           

  Cat() {
    super(stage);
    spriteFolder("cat");             
    setSizeTo(10);
    pointInDirection(random(-180, 180));
  }

  void draw() {                      
    display();
    move(10);
    if (touch("edge")) {
      itsRainningCats.remove(this);     // Delete the clone by removing it to the ArrayList, this because it's in the class. Outside you need to get(it)
    }
  }

}
