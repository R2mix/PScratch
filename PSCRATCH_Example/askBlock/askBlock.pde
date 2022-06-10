Cat cat;                        
Stage stage;                    

void setup() {                  
  size(800,600);
  stage = new Stage("scenes");   
  cat= new Cat();    
}                                

void draw () {                 
  stage.backdrops();            
  cat.draw();                    
}        


void keyPressed() {              // called when a key is pressed
  keyIsDown();                   // check if all keys are pressed or not
}

void keyReleased() {             // called when a key is released
  keyIsUp();                     // check if all keys are released or not
}
