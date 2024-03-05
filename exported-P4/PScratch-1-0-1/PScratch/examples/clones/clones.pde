import processing.sound.*;
import R2mix.PScratch.*;

ArrayList<Cat> itsRainningCats = new ArrayList<Cat>(); // the array that contains the class to clone

Stage stage;
Sounds sounds;

void setup() {
  size(800, 600);
  stage = new Stage(this,"scenes");
  sounds = new Sounds(stage, "sounds");
}

void draw () {
  stage.backdrops();
  Clones();                                               // clones creation and display fonction
}

void Clones() {

  //---------------Create clones of cat------------------
  if (stage.keyIsPressed(' ')  ) {                              // condition for add a clone
    itsRainningCats.add(new Cat());                       // add a clone to the arrayList
  }
  //--------------Display clones of cat------------------
  stage.drawClones(itsRainningCats);
}


void keyPressed() {
  stage.keyIsDown();
}

void keyReleased() {
  stage.keyIsUp();
}
