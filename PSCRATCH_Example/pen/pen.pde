Cat cat;                        
Stage stage;                    

void setup() {                  
  fullScreen();
  stage = new Stage("scenes");   
  cat= new Cat();    
}                                

void draw () {                 
  stage.backdrops();            
  pickColor();
  cat.draw();                    
}                               
