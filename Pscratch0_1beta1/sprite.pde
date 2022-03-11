class sprite {

  PImage [] costume; // tableau pour stocker les différentes images du sprite
  float x, y, angleDegre, angleRadian; // position x Y, angle et angle en radian du sprite
  int currentImage; // variable pour savoir quelle variable on va utilisecurrentImager
  color getColor; 
  color effetCouleur = -1; // pour connaitre la couleur dectée et changer la couleur de l'image
  color effetFantome = 255; // alpha de tint pour l'effet couleur
  int [] tailleOrigine;  

  sprite( String SpriteName, int costumeNumber) { // choisir le nom du sprite, le nombre de costume
    costume = new PImage [costumeNumber]; // initialise le tableau des costumes
    tailleOrigine = new int [costumeNumber]; // stocke la taille d'origine
    x = width/2; // position de départ par défaut
    y = height/2; // position de départ par défaut
    for (int i = 0; i < costume.length; i++) { // répeter pour la longueur de la liste de charger les images contenant costume et le numéro correspondant à leur position dans le tableau
      costume[i] = loadImage(SpriteName + i + ".png"); // charge les costumes
      tailleOrigine[i] = costume[i].width;
    }
  }

  void affiche() {

    push(); // délimite le champ d'action entre push et pop
    translate(x, y); // déplace le centre du programme sur le chat
    rotate(angleRadian); // oriente le chat
    colorTouch(); // lance la detection de couleur
    tint(effetCouleur, effetFantome); // l'effet couleur
    imageMode(CENTER); // le centre de l'image devient le centre 
    image(costume[currentImage], 0, 0 );// met l'image en son centre (à rajouter une void pour déplacer le centre ??)
    pop(); //fin du champ d'action
  }

  void changerTaille(int t) {
    // change la taille de tous les costumes chargés en %
    for (int i = 0; i < costume.length; i++) { // répeter pour la longueur de la liste de charger les images contenant costume et le numéro correspondant à leur position dans le tableau
      costume[i].resize( tailleOrigine[i] * t/100, 0); //met leur taille en pourcentage  // costume[i].resize( costume[i].width * tailleSprite/100, costume[i].height * tailleSprite/100);
    }
  }
  void ajouterTaille(int t) {
    // change la taille de tous les costumes chargés en %
    for (int i = 0; i < costume.length; i++) { // répeter pour la longueur de la liste de charger les images contenant costume et le numéro correspondant à leur position dans le tableau
      costume[i].resize( costume[i].width + t, 0); //met leur taille en pourcentage  // costume[i].resize( costume[i].width * tailleSprite/100, costume[i].height * tailleSprite/100);
    }
  }


  void allerA(float xx, float yy) { // déplace à l'endroit shouaité
    x = xx;
    y = yy;
  }

  void ajouterX(float add) {
    x += add;
  }
  void ajouterY(float add) {
    y += add;
  }
  void mettreX(float a) {
    x = a;
  }
  void mettreY(float a) {
    y = a;
  }

  void avancer(float a) { // avancer dans la direction de l'angle choisi
    x += cos(angleRadian) * a;
    y += sin(angleRadian) * a;
  }

  void orienter(float a) { // oriente en degré pui le converti en radian pour la fonction rotate
    angleDegre = a;
    angleRadian = radians(angleDegre);
  }

  void costume( int c) { // change le costume du personnage
    currentImage = c;
  }

  void orienterVers(float xx, float yy) { // oriente le personnage vers deux coordonnées
    angleRadian = atan2(yy - y, xx - x);
  }

  void colorTouch() { // scan les couleurs sous le lutin
    for (int i = -costume[currentImage].width/2; i < costume[currentImage].width/2; i++) {
      for (int j = -costume[currentImage].height/2; j < costume[currentImage].height/2; j++) {

        getColor = get (int (x + i), int ( y + j)); // récupère la couleur dont la zone est définie par la double FOR
      }
    }
  }


  boolean toucheCouleur(color col) { // boolean à appeler dans une condition pour la couleur
    if (getColor == col) {
      return true;
    } else {
      return false;
    }
  }

  boolean touche(float xx, float yy, float l, float h) { // hit box comparée entre 2 sprites
    if ( x + costume[currentImage].width/2 > xx - l /2 && 
      x - costume[currentImage].width/2 < xx + l/2 &&
      y + costume[currentImage].height/2 > yy - h/2 &&
      y - costume[currentImage].height/2 < yy + h/2 ) {
      return true;
    } else {
      return false;
    }
  }

  boolean toucheSouris() { // si touche le pointeur de souris
    if ( x + costume[currentImage].width/2 > mouseX && 
      x - costume[currentImage].width/2 < mouseX &&
      y + costume[currentImage].height/2 > mouseY &&
      y - costume[currentImage].height/2 < mouseY ) {
      return true;
    } else {
      return false;
    }
  }
}

//---Main fonction----

void attendre(float t) { // blocs attendre en sec
  delay(int (t * 1000)); // delay en millisecondes, ici converti depuis les secondes
}


/*

 private void quandLeProgrammeDemarre() { // ---void contenant les threads asynchrones----
 
 
 new Thread(new Runnable() { // créer un nouveau thread qui se lance au démarrage du jeu
 public void run() {
 //----mettre les actions ici;
 for (int i = 0; i < 10; i++) { // boucle répéter 10 fois le i<10 correspond au nombre de répétition
 
 attendre(1); // attendre 1 seconde
 }
 
 //----fin des actions
 }
 }
 ).start(); // lancement du thread
 }// ------------ fin des threads-------------
 */
