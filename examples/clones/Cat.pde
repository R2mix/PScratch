class Cat extends Sprite {           

  Cat() {
    super(stage, "cat");
    setSizeTo(10);
    pointInDirection(random(-180, 180));
  }

  void draw() {                      
    display();
    move(10);
    if (touch("edge")) {
     deleteThisClone();     // Delete the clone by removing it to the ArrayList, this because it's in the class. Outside you need to get(it)
    }
  }

}
