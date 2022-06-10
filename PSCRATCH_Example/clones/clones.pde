ArrayList<Cat> itsRainningCats = new ArrayList<Cat>(); // the array that contains the class to clone

Stage stage;

void setup() {
  size(800, 600);
  stage = new Stage("scenes");
  soundFolder("sounds");
}

void draw () {
  stage.backdrops();
  Clones();                                               // clones creation and display fonction
}

void Clones() {

  //---------------Create clones of cat------------------
  if (keyIsPressed(' ')  ) {                              // condition for add a clone
    itsRainningCats.add(new Cat());                       // add a clone to the arrayList
  }
  //--------------Display clones of cat------------------
  for (int i = itsRainningCats.size() - 1; i >= 0; i--) { // iterate for each clones
    Cat cat = itsRainningCats.get(i);                     // get the current clone instance
    cat.draw();                                           // display each clone
  }
}


void keyPressed() {
  keyIsDown();
}

void keyReleased() {
  keyIsUp();
}
