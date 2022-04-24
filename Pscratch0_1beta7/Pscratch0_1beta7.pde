Cat cat; // créer un nouveau sprite
Scene scene;


void setup() { // --- quand le programme démarre
  size(800, 600); // la taille de l'écran de jeu (largeur hauteur)

  //-----initialiser les sprites
  cat= new Cat(); //  nom du ou des costumes, nombre de costumes
  scene = new Scene("scenes");  // scène, peut recevoir une image.
  soundFolder("sounds");
  playSound(0);
}


void draw () {//-----programme répété indéfiniment-----

  scene.backdrops();
  //pickColor();
  cat.draw();
}//----fin de la répétition infinie -----
