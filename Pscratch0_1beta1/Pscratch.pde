sprite cat; // créer un nouveau sprite


void setup() { // --- quand le programme démarre
  size(800, 600); // la taille de l'écran de jeu (largeur hauteur)


  //-----initialiser les sprites
  cat= new sprite("cat", 2); // initialiser le nouveau sprite. Toute les actions doivent être appellées ainsi : nomdusprite.action();
  //-----les threads au démarrage  
  thread(""); // lance tous les threads
}

void draw () {//-----programme répété indéfiniment-----
  background(#FFFFFF); // scène, peut recevoir une couleur unique ou une image.
  cat.affiche();;
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
