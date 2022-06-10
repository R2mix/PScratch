class Cat extends Sprite {

  Cat() {
    spriteFolder("cat");
  }

  void draw() {
    display();
    println(answer);                                       // print the answer into the consol for program checking
    if (touch("mouse") && mousePressed && !isAsking) {     // ask when touch and mousepressed, check is already asking
      ask("Hello, what is your name ?");                    
    }
    if ( answer.length() > 1 && !isAsking ) {              // check if the answer is not empty and if is asking
      say("Hello " + answer + " !");                       // say hello and the answer, + is for add to a string multiple variables
    }
  }
}
