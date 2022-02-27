class Cat extends Sprite {

  Cat(String costumeName, int costumeNumb) {
    super(costumeName, costumeNumb);
     changerTaille(50);
  }

  void draw() {
    montrer();
  }
}
