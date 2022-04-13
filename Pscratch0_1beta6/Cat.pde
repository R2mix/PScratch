class Cat extends Sprite {

  Cat() {
    super();
    chargementDesCostumes("cat", 2);
    changerTaille(50);
    chargementDesSons("groove", 1);
    jouerUnSon(0);
  }


  void draw() {
    montrer();
  }
}
