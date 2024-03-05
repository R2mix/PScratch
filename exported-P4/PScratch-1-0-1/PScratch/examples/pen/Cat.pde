class Cat extends Sprite {
  Pen pen;                               // create a pen object
  
  int repeat = 60, totalRepeat = 10;     // variables for repeat
  
  Cat() {
    super(stage, "cat");
    pen = new Pen(stage, this);                     // initialize the pen
    turnLeft(15);
  }

  void draw() {

    pen.attach(this);                    // you must attach the pen to a sprite (this) for example. 
                                         //If you don't the pen will not follow the sprite
    pen.penDown();                       // put the pen on the drawing surface

    if (repeat > 0) {                    // when repeat
      pen.changePenColorBy(1);           // change the color each frame
      pen.changePenSizeBy(1);            // change the size of the pen each frame
      repeat-= 1;                        // decrement until it's 0
    } else {
      repeat = 60;                       // reset the repeat
      totalRepeat-= 1;                   // for the other repeat
      pen.setPenColorTo(random(200));    // set a random color
      pen.setPenSizeTo(1);               // set the size to 1 pixel
      pen.stamp(this);                   // stamp this sprite on the drawing surface
    }


    if (totalRepeat < 0) {               // the other repeat
      totalRepeat = 10;                  // reset the repeat
      pen.eraseAll();                    // erase the drawing surface and start again
    }


    move(10);
    ifOnEdgeBounce();

    display();
  }
}
