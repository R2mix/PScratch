class Chick extends Sprite {           

  Chick() {
    super(stage, "chick");                       
    setRotationStyle("left-right"); 
    setSizeTo(50);                        // set size of the sprite smaller than the paths into the labyrinth
    goTo(80, 535);                        // go to the start position
  }


  void draw() {                      
    display();
    //-------------------------------- smooth mouvements on the frameRate -----------------------------
    if (keyIsPressed("upArrow")) {        // if selected key is pressed
      pointInDirection(-90);              // set te direction of the sprite
      move(4);                            // move in this direction
    }
    if (keyIsPressed("downArrow")) {
      pointInDirection(90); 
      move(4);
    }
    if (keyIsPressed("leftArrow")) {
      pointInDirection(180); 
      move(4);
    }
    if (keyIsPressed("rightArrow")) {
      pointInDirection(0); 
      move(4);
    } 
    //-------------------------------- ------------------------------------ -----------------------------
  }

  void run() {   
    for (;; ) {                        // repeat forever
      //-------------------------------- if touch the color of the walls, go to the start position -----------------------------
      if (touch(#FFA71700)) {
        goTo(80, 535);
        sounds.playSound(0);
      }
      //-------------------------------- if touch the color of the end, says victory and play a sound -----------------------------
      if (touch(#FFFED200)) {
        sounds.playSound(0);
        say("Victory !", 2);
      }
      //-------------------------------- animation of the mouvement when one of arrow is pressed -----------------------------
      if (keyIsPressed("rightArrow")||keyIsPressed("leftArrow")||keyIsPressed("downArrow")||keyIsPressed("upArrow")) {
        nextCostume();
      } 

      stage.Wait(0.1);                       // wait in each repetition for animation speed and refresh speed, obligatory
    }
  }
}
