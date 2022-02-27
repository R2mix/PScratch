



class Sprite {

  PImage [] costumes; // tableau pour stocker les différentes images du sprite
  float x, y, angleDegre, angleRadian, gravity; // position x Y, angle et angle en radian du sprite et la gravité si activée
  int costume; // variable pour savoir quelle variable on va utilisecostumer
  color getColor, getColorFloor;
  color effetCouleur = -1; // pour connaitre la couleur dectée et changer la couleur de l'image
  color effetFantome = 255; // alpha de tint pour l'effet couleur
  int [] taille; // tableau pour stocker les tailles
  boolean fixerRotation; // empeche le sprite de tourner
  IntList colorStored, colorStoredFloor; // tableau pour la detection de couleur
  boolean detecterCouleur = true; // active/désactive la detection de couleur du personnage
  int son;// variable pour savoir le son joué





  Sprite( ) { // choisir le nom du sprite, le nombre de costumes   String nomSprite, int nombreCostumes

    x = width/2; // position de départ par défaut
    y = height/2; // position de départ par défaut

    colorStored = new IntList(); // liste pour stocker les couleurs dans la hitbox du sprite
    colorStoredFloor = new IntList(); // liste pour stocker les couleurs dans la hitbox du sprite

    /* for (int i = 0; i < costumes.length; i++) { // répeter pour la longueur de la liste de charger les images contenant costumes et le numéro correspondant à leur position dans le tableau
     costumes[i] = loadImage(nomSprite + i + ".png"); // charge les costumess
     taille[i] = costumes[i].width;
     }*/
  }

  void chargementDesCostumes(String nomSprite, int nombreCostumes) {

    costumes = new PImage [nombreCostumes]; // initialise le tableau des costumess
    taille = new int [nombreCostumes]; // stocke la taille d'origine
    for (int i = 0; i < costumes.length; i++) { // répeter pour la longueur de la liste de charger les images contenant costumes et le numéro correspondant à leur position dans le tableau
      try {
        costumes[i] = loadImage(nomSprite + i + ".png"); // charge les costumess
        taille[i] = costumes[i].width;
      }
      catch (Exception e) {
        println("Costume manquant ou introuvable");
      }
    }
  }



  void montrer() {

    push(); // délimite le champ d'action entre push et pop
    translate(x, y); // déplace le centre du programme sur le chat
    if (!fixerRotation) rotate(angleRadian); // oriente le chat
    if (detecterCouleur) colorTouch(); // lance la detection de couleur
    tint(effetCouleur, effetFantome); // l'effet couleur
    imageMode(CENTER); // le centre de l'image devient le centre
    image(costumes[costume], 0, 0 );// met l'image en son centre (à rajouter une void pour déplacer le centre ??)

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
    int l = costumes[costume].width/2;
    int h = costumes[costume].height/2;
    colorStoredFloor.clear(); //vide le tableau entre chaque frame

    for (int i = 0; i < costumes[costume].width; i++) {
      int  getColorSprite = costumes[costume].get(  i, h - 2  ); // récupère la couleur dont la zone est définie par la double FOR

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
    // change la taille de tous les costumess chargés en %
    for (int i = 0; i < costumes.length; i++) { // répeter pour la longueur de la liste de charger les images contenant costumes et le numéro correspondant à leur position dans le tableau
      costumes[i].resize( taille[i] * t/100, 0); //met leur taille en pourcentage  // costumes[i].resize( costumes[i].width * tailleSprite/100, costumes[i].height * tailleSprite/100);
    }
  }
  void ajouterTaille(int t) {
    // change la taille de tous les costumess chargés en %
    for (int i = 0; i < costumes.length; i++) { // répeter pour la longueur de la liste de charger les images contenant costumes et le numéro correspondant à leur position dans le tableau
      costumes[i].resize( costumes[i].width + t, 0); //met leur taille en pourcentage  // costumes[i].resize( costumes[i].width * tailleSprite/100, costumes[i].height * tailleSprite/100);
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

  void costumes( int c) { // change le costumes du personnage
    costume = c;
  }

  void orienterVers(float xx, float yy) { // oriente le personnage vers deux coordonnées
    angleRadian = atan2(yy - y, xx - x);
  }

  void colorTouch() { // scan les couleurs sous le lutin
    int l = costumes[costume].width/2;
    int h = costumes[costume].height/2;
    colorStored.clear(); //vide le tableau entre chaque frame

    for (int i = 0; i < costumes[costume].width; i++) {
      for (int j = 0; j < costumes[costume].height; j++) {

        int  getColorSprite = costumes[costume].get(  i, j  ); // récupère la couleur dont la zone est définie par la double FOR
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
    if ( x + costumes[costume].width/2 > xx - l /2 &&
      x - costumes[costume].width/2 < xx + l/2 &&
      y + costumes[costume].height/2 > yy - h/2 &&
      y - costumes[costume].height/2 < yy + h/2 ) {
      return true;
    } else {
      return false;
    }
  }

  boolean toucheSouris() { // si touche le pointeur de souris
    if ( x + costumes[costume].width/2 > mouseX &&
      x - costumes[costume].width/2 < mouseX &&
      y + costumes[costume].height/2 > mouseY &&
      y - costumes[costume].height/2 < mouseY ) {
      return true;
    } else {
      return false;
    }
  }
}


//---Main fonction----


import processing.sound.*;
SoundFile[] sons;
void chargementDesSons(String nomSon, int nombreSon) {
  sons = new SoundFile[nombreSon];


  for (int i = 0; i < nombreSon; i++) { // répeter pour la longueur de la liste de charger les images contenant costumes et le numéro correspondant à leur position dans le tableau
    try {
      sons[i] =  new SoundFile(this, nomSon + i + ".mp3"); // charge les costumes
    }
    catch (Exception e) {
      println("Son manquant ou introuvable");
    }
  }
}
void jouerUnSon(int numeroSon) {
  sons[numeroSon].play();
}
void arreterUnSon(int numeroSon) {
  sons[numeroSon].stop();
}



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

long compteur, chronometre;



class Scene {

  PImage [] fond; // tableau pour stocker les différentes images du sprite
  int costume; // variable pour savoir quelle variable on va utilisecostumer

  Scene( String sceneName, int nombreCostumes) { // choisir le nom du sprite, le nombre de costumes
    fond = new PImage [nombreCostumes]; // initialise le tableau des costumess

    for (int i = 0; i < fond.length; i++) { // répeter pour la longueur de la liste de charger les images contenant costumes et le numéro correspondant à leur position dans le tableau
      fond[i] = loadImage(sceneName + i + ".png"); // charge les costumess
      fond[i].resize(width, height);
    }
  }

  void arrierePlan() {
    background(fond[costume] );
    compteur = frameCount;
    chronometre = millis();
  }
  void changerArrierePlan( int c) { // change le costumes du personnage
    costume = c;
  }
}


/*class clonesClass extends sprite{
 
 clonesClass (String costumesName, int costumesNumb){
 super(costumesName, costumesNumb);
 }
 
 void action(){
 affiche();
 
 }
 }*/
