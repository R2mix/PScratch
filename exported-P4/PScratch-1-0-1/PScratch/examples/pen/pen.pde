import R2mix.PScratch.*;
import processing.sound.*;

Cat cat;                        
Stage stage;                    

void setup() {                  
  fullScreen();
  stage = new Stage(this, "scenes");   
  cat= new Cat();    
}                                

void draw () {                 
  stage.backdrops();            
  cat.draw();                    
}                               
