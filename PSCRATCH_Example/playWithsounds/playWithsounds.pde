Instruments drum, guitar;
Stage stage;

void setup() {
  size(800, 600);
  soundFolder("sounds");         // loadSounds into soundsFolder (can be renamed)
  stage = new Stage("scenes");
  drum= new Instruments(200, 200, 1);
  guitar= new Instruments(600, 200, 0);
}

void draw () {
  stage.backdrops();
  pickColor();
  drum.draw();
  guitar.draw();
}

void mousePressed() {
  drum.mousePressed(1);
  guitar.mousePressed(0);
}
