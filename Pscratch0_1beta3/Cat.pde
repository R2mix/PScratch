class Cat extends sprite {

  Cat(String costumeName, int costumeNumb) {
    super(costumeName, costumeNumb);
     changerTaille(50);
  }

  void montrer() {
    affiche();
  }
}
