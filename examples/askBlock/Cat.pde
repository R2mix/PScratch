class Cat extends Sprite {

  Cat() {
    super(stage, "cat");
  }

  void draw() {
 if (touch("mouse") && mousePressed && !stage.isAsking) {     // ask when touch and mousepressed, check is already asking
      ask("Hello, what is your name ?");                    
    }
    if ( stage.answer.length() > 1 && !stage.isAsking ) {              // check if the answer is not empty and if is asking
      say("Hello " + stage.answer + " !");                       // say hello and the answer, + is for add to a string multiple variables
    }
   
        display();
  }
  
  void run(){
      askAndWait("Hello, what is your name ?");   
      say("Hello " + stage.answer + " !");                       // say hello and the answer, + is for add to a string multiple variables
  }
  
}
