Chick chick;
Stage stage;

void setup() {
  size(800, 600);
  stage = new Stage("scenes");
  soundFolder("sounds");
  chick = new Chick();
}

void draw () {
  stage.backdrops();
  pickColor();                       // pick the color and print it to the console
  println(mouseX, mouseY);           // print the position x and y of the mouse
  chick.draw();
}



void keyPressed() {
  keyIsDown();
}

void keyReleased() {
  keyIsUp();
}
