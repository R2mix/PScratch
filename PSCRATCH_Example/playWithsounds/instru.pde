class Instruments extends Sprite {

  Instruments(float posX, float posY, int c) {    // set a position and a costume when sprite start
    spriteFolder("instru");                     
    goTo(posX, posY);
    switchCostumeTo(c);
  }

  void draw() {
    display();

    setPitchEffectTo(map(mouseX, 0, width, 0, 200));  // change the pitch with the mouseX position
  }

  void mousePressed(int soundFile) {    // play the soundfile selected
    if (touch("mouse")) {
      playSound(soundFile);
    }
  }
}
