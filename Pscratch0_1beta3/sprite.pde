class sprite {

  PImage [] costume; // tableau pour stocker les différentes images du sprite
  float x, y, angleDegre, angleRadian, gravity; // position x Y, angle et angle en radian du sprite et la gravité si activée
  int currentImage; // variable pour savoir quelle variable on va utilisecurrentImager
  color getColor, getColorFloor;
  color effetCouleur = -1; // pour connaitre la couleur dectée et changer la couleur de l'image
  color effetFantome = 255; // alpha de tint pour l'effet couleur
  int [] tailleOrigine;
  boolean fixerRotation;
  IntList colorStored, colorStoredFloor;

  sprite( String SpriteName, int costumeNumber) { // choisir le nom du sprite, le nombre de costume
    costume = new PImage [costumeNumber]; // initialise le tableau des costumes
    tailleOrigine = new int [costumeNumber]; // stocke la taille d'origine
    x = width/2; // position de départ par défaut
    y = height/2; // position de départ par défaut

    colorStored = new IntList(); // liste pour stocker les couleurs dans la hitbox du sprite
    colorStoredFloor = new IntList(); // liste pour stocker les couleurs dans la hitbox du sprite

    for (int i = 0; i < costume.length; i++) { // répeter pour la longueur de la liste de charger les images contenant costume et le numéro correspondant à leur position dans le tableau
      costume[i] = loadImage(SpriteName + i + ".png"); // charge les costumes
      tailleOrigine[i] = costume[i].width;
    }
  }

  void affiche() {
    push(); // délimite le champ d'action entre push et pop
    translate(x, y); // déplace le centre du programme sur le chat
    if (!fixerRotation) rotate(angleRadian); // oriente le chat
    colorTouch(); // lance la detection de couleur
    tint(effetCouleur, effetFantome); // l'effet couleur
    imageMode(CENTER); // le centre de l'image devient le centre
    image(costume[currentImage], 0, 0 );// met l'image en son centre (à rajouter une void pour déplacer le centre ??)

    pop(); //fin du champ d'action
  }


  float sautActuel = 1;
  boolean saut;

  void saute(int s ) { // saut pendant un certain nombre de pixel de manière naturelle


    if ( sautActuel < s*2 && saut ) { // saut permet de savoir si le saut est activé, si actif repeter 2 fois la longueur de s pour passer en négatif et retomber. Saut actuel doit commencer à 1 sinon décalage
      y +=  sautActuel  - s; // saute puis descend
      sautActuel+= 1; // itération et gravité
    } else if ( sautActuel < s*2 && sautActuel != 1) { // même chose si jamais SAUT n'est pas maintenu
      y +=  sautActuel  - s ; // même chose si jamais SAUT n'est pas maintenu
      sautActuel+= 1;
    } else {
      sautActuel = 1; // remet les variable à zero après le saut
      saut = false;
    }
  }

  void grounded() { // scan les couleurs sous le lutin
    int l = costume[currentImage].width/2;
    int h = costume[currentImage].height/2;
    colorStoredFloor.clear(); //vide le tableau entre chaque frame

    for (int i = 0; i < costume[currentImage].width; i++) {
      int  getColorSprite = costume[currentImage].get(  i, h - 2  ); // récupère la couleur dont la zone est définie par la double FOR

      if (getColorSprite < 0) { // cherche uniquement dans la zone du sprite contenant de la couleur
        getColorFloor = get (int (x + i - l), int (y + h + 2)); // récupère la couleur dont la zone est définie par la double FOR sur l'image du sprite
        colorStoredFloor.append(getColorFloor);
      }
    }
  }

  boolean toucheSol(color col) { // boolean à appeler dans une condition pour la couleur
    if (colorStoredFloor.hasValue(col) ) { //si le tableau de couleur contient la couleur touchée.
      return true;
    } else {
      return false;
    }
  }

  //----------à finir
  void sautGravite(int s, boolean colo1, boolean colo2) { // hauteur du saut et couleur de référence pour le sol

    grounded(); // check si touche le sol

    if (!saut && !colo1 &&  sautActuel == 1 ) { // si touche pas le sol et ne saut pas il tombe
      y += gravity;  // tombe
      gravity ++; // acceleration de la chtue
    }
    if ( sautActuel < s && saut ) { // saut permet de savoir si le saut est activé, si actif repeter 2 fois la longueur de s pour passer en négatif et retomber. Saut actuel doit commencer à 1 sinon décalage
      y +=  sautActuel  - s; // saute puis descend
      sautActuel+= 1; // itération et gravité
    } else if ( sautActuel < s && sautActuel != 1) { // même chose si jamais SAUT n'est pas maintenu
      y +=  sautActuel  - s ; // même chose si jamais SAUT n'est pas maintenu
      sautActuel+= 1;
    } else if (sautActuel >= s && !colo1) { // tombe à la fin du saut
      y += gravity;  // tombe
      gravity ++; // acceleration de la chtue
    } else  if ( colo1 && colo2) { // rebondi sur le sol si trop enfoncer
      y -= 5;
    } else  if (sautActuel >= s && colo1) { // reset le saut
      sautActuel = 1; // remet les variable à zero après le saut
      saut = false;
      gravity = 0;
    }
  }
  //---------/à finir


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
    int l = costume[currentImage].width/2;
    int h = costume[currentImage].height/2;
    colorStored.clear(); //vide le tableau entre chaque frame

    for (int i = 0; i < costume[currentImage].width; i++) {
      for (int j = 0; j < costume[currentImage].height; j++) {

        int  getColorSprite = costume[currentImage].get(  i, j  ); // récupère la couleur dont la zone est définie par la double FOR
        getColor = get (int (x + i), int ( y + j)); // récupère la couleur dont la zone est définie par la double FOR sur l'image du sprite

        if (getColorSprite < 0) { // cherche uniquement dans la zone du sprite contenant de la couleur
          colorStored.append( getColor = get (int (x + i - l), int ( y + j - h))); // stocke dans un tableau pour la boolean plus tard
        }
      }
    }
  }


  boolean toucheCouleur(color col) { // boolean à appeler dans une condition pour la couleur
    if (colorStored.hasValue(col) ) { //si le tableau de couleur contient la couleur touchée.
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

void selectionerCouleur() {
  println(get(mouseX, mouseY));
  push();
  textSize(16);
  fill(0, 255, 0);
  text(get(mouseX, mouseY), 20, 20);
  pop();
}

class scene {

  PImage [] fond; // tableau pour stocker les différentes images du sprite
  int currentImage; // variable pour savoir quelle variable on va utilisecurrentImager

  scene( String sceneName, int costumeNumber) { // choisir le nom du sprite, le nombre de costume
    fond = new PImage [costumeNumber]; // initialise le tableau des costumes

    for (int i = 0; i < fond.length; i++) { // répeter pour la longueur de la liste de charger les images contenant costume et le numéro correspondant à leur position dans le tableau
      fond[i] = loadImage(sceneName + i + ".png"); // charge les costumes
      fond[i].resize(width, height);
    }
  }

  void arrierePlan() {
    background(fond[currentImage] );// met l'image en son centre (à rajouter une void pour déplacer le centre ??)
  }
  void changerArrierePlan( int c) { // change le costume du personnage
    currentImage = c;
  }
}


/*class clonesClass extends sprite{
 
 clonesClass (String costumeName, int costumeNumb){
 super(costumeName, costumeNumb);
 }
 
 void action(){
 affiche();
 
 }
 }*/
