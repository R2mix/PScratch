Cat cat; // créer un nouveau sprite
scene arrierePlan;

void setup() { // --- quand le programme démarre
  size(800, 600); // la taille de l'écran de jeu (largeur hauteur)

  //-----initialiser les sprites
  cat= new Cat("cat", 2); //  nom du ou des costumes, nombre de costumes
  arrierePlan = new scene("Blue Sky", 1);  // scène, peut recevoir une image.
}



void draw () {//-----programme répété indéfiniment-----

  arrierePlan.arrierePlan();
  cat.montrer();
}//----fin de la répétition infinie -----


void keyPressed() { // ---quand une touche du clavier est pressée---
} // ----fin de  : quand une touche du clavier est pressée---


void keyReleased() { // ---quand une touche du clavier est relachée---
}// ----fin de  : quand une touche du clavier est relachée---


void mousePressed() { // ---quand la souris est pressée---
}// ----fin de  : quand la souris  est pressée---

void mouseReleased() { // ---quand la souris est relachée---
} // ----fin de  : quand la souris  est relachée---


void mouseMoved() { // ---quand la souris est bougée---
}// ----fin de  : quand la souris  est bougée---
