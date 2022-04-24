import processing.sound.*;

class Sprite {

  float x, y, direction, angleRadian, spriteWidth, spriteHeight; // position x Y, angle et angle en radian du sprite et la gravité si activée
  int costume, spriteSize; // variable pour savoir quelle variable on va utilisecostumer
  color colorEffectValue = -1; // pour connaitre la couleur dectée et changer la couleur de l'image
  color gostEffectValue = 255; // alpha de tint pour l'effet couleur
  boolean setRotationStyle, dragable; // empeche le sprite de tourner
  IntList colorStored; // tableau pour la detection de couleur
  boolean spriteColorDetection = true; // active/désactive la detection de couleur du personnage

  //-------import sounds and images ---
  PImage [] costumes; // array of images
  //-----------------------------------

  Sprite( ) { // choisir le nom du sprite, le nombre de costumes   String nomSprite, int nombreCostumes

    x = width/2; // position de départ par défaut
    y = height/2; // position de départ par défaut
    colorStored = new IntList(); // liste pour stocker les couleurs dans la hitbox du sprite
  }

  //====================================== Sprite folder research =====================================================================================================================


  void spriteFolder(String folder) {

    String path = sketchPath()+ "/data/" + folder; // search for folderpath
    String[] filenames = listFileNames(path); // search filenames
    printArray(filenames); // print names
    int totalNumberOfCostumes = 0;
    int loadedCostume = 0;
    for (int i = 0; i < filenames.length; i++) {
      String extention = filenames[i].substring(filenames[i].indexOf(".")); // separate extention for separate img to sounds and prevent otherfiles
      //images
      if (extention.equals(".png") || extention.equals(".jpg") || extention.equals(".jpeg") || extention.equals(".tga") || extention.equals(".gif") ) {
        totalNumberOfCostumes++;   // var for knowing the number of images
      }
    }
    costumes = new PImage [totalNumberOfCostumes]; // array of images
    for (int i = 0; i < filenames.length; i++) {
      String extention = filenames[i].substring(filenames[i].indexOf("."));
      //images
      if (extention.equals(".png") || extention.equals(".jpg") || extention.equals(".jpeg") || extention.equals(".tga") || extention.equals(".gif") ) {
        costumes[loadedCostume] = loadImage(path +"/"+ filenames[i]); // charge les costumess
        loadedCostume++;
      }
    }
  }

  //====================================== Show sprite and main sprite functions =====================================================================================================================

  void show() {

    spriteWidth = costumes[costume].width;
    spriteHeight =  costumes[costume].height;
    push(); // délimite le champ d'action entre push et pop
    translate(x, y); // déplace le centre du programme sur le chat
    if (!setRotationStyle) rotate(angleRadian); // oriente le chat
    if (spriteColorDetection) spriteColorDetector(); // lance la detection de couleur
    tint(colorEffectValue, gostEffectValue); // l'effet couleur
    imageMode(CENTER); // le centre de l'image devient le centre
    image(costumes[costume], 0, 0 );// met l'image en son centre (à rajouter une void pour déplacer le centre ??)
    pop(); //fin du champ d'action
    dragSprite();
  }

  //====================================== Motion =====================================================================================================================

  void move(float a) { // avancer dans la direction de l'angle choisi
    x += cos(angleRadian) * a;
    y += sin(angleRadian) * a;
  }
  void turnRight(float a) {
    direction += a;
    direction = direction%360;
    angleRadian = radians(direction);
  }
  void turnLeft(float a) {
    direction -= a;
    direction = direction%-360;
    angleRadian = radians(direction);
  }
  void goTo(String s) { // déplace à l'endroit shouaité
    if (s == "mouse") {
      x = mouseX;
      y = mouseY;
    }
    if (s == "randomPosition") {
      x = random(width);
      y = random(height);
    }
  }
  void goTo(Sprite o) { // déplace à l'endroit shouaité
    x = o.x;
    y = o.y;
  }
  void goTo(float xx, float yy) { // déplace à l'endroit shouaité
    x = xx;
    y = yy;
  }
  void pointInDirection(float a) { // oriente en degré pui le converti en radian pour la fonction rotate
    direction = a;
    angleRadian = radians(direction);
  }
  void pointToward(float xx, float yy) { // oriente le personnage vers deux coordonnées
    angleRadian = atan2(yy - y, xx - x);
  }
  void pointToward(String mouseIn) { // oriente le personnage vers deux coordonnées
    if (mouseIn == "mouse")angleRadian = atan2(mouseY - y, mouseX - x);
  }
  void pointToward(Sprite o) { // oriente le personnage vers deux coordonnées
    angleRadian = atan2(o.y - y, o.x - x);
  }
  void changeXBy(float add) {
    x += add;
  }
  void setX(float a) {
    x = a;
  }
  void changeYBy(float add) {
    y += add;
  }
  void setY(float a) {
    y = a;
  }
  void ifOnEdgeBounce() { // rebondit sur les différents bord
    if ( x+ spriteWidth/2 > width) pointInDirection(180 - direction);
    if (x - spriteWidth/2 < 0) pointInDirection(180 - direction);
    if (y + spriteHeight/2 > height) pointInDirection(direction * -1);
    if (y - spriteHeight/2 < 0) pointInDirection(direction * -1);
  }
  void setRotationStyle(boolean b) { // fixe le sens de rotation
    setRotationStyle = b;
  }

  //====================================== Looks =====================================================================================================================

  void say(String txt) {
    push();
    translate(x, y);
    fill(255);
    noStroke();
    rectMode(CENTER);
    rect( spriteWidth/2, - spriteHeight/2, txt.length() * (spriteWidth/16), spriteWidth/4, 25);
    triangle(spriteWidth/3, - spriteHeight/2, spriteWidth/3, -spriteHeight/4, spriteWidth/2, -spriteHeight/2 );
    fill(0);
    textSize(spriteWidth/8);
    textAlign(CENTER);
    text(txt, spriteWidth/2, - spriteHeight/2);
    pop();
  }
  void think (String txt) {
    push();
    translate(x, y);
    fill(255);
    noStroke();
    rectMode(CENTER);
    rect( spriteWidth/2, - spriteHeight/2, txt.length() * (spriteWidth/16), spriteWidth/4, 25);
    circle( spriteWidth/3, - spriteHeight/3, spriteWidth/16);
    fill(0);
    textSize(spriteWidth/8);
    textAlign(CENTER);
    text(txt, spriteWidth/2, - spriteHeight/2);
    pop();
  }
  void switchCostumeTo( int c) { // change le costumes du personnage
    costume = c;
  }
  void nextCostume() { // bascule sur le costume suivant
    costume++;
    costume = costume%costumes.length;
  }
  void changeSizeBy(int t) {
    // change la taille de tous les costumess chargés en %
    spriteSize += t;
    for (int i = 0; i < costumes.length; i++) { // répeter pour la longueur de la liste de charger les images contenant costumes et le numéro correspondant à leur position dans le tableau
      costumes[i].resize( costumes[i].width + spriteSize, 0); //met leur taille en pourcentage  // costumes[i].resize( costumes[i].width * tailleSprite/100, costumes[i].height * tailleSprite/100);
    }
  }
  void setSize(int t) {
    // change la taille de tous les costumess chargés en %
    spriteSize = t;
    for (int i = 0; i < costumes.length; i++) { // répeter pour la longueur de la liste de charger les images contenant costumes et le numéro correspondant à leur position dans le tableau
      costumes[i].resize( costumes[i].width * spriteSize/100, 0); //met leur taille en pourcentage  // costumes[i].resize( costumes[i].width * tailleSprite/100, costumes[i].height * tailleSprite/100);
    }
  }
  void changeColorEffectBy(int col) {
    // change la taille de tous les costumess chargés en %
    colorEffectValue -= col * 0.01 * 16777215;
  }
  void setColorEffectTo(int col) {
    // change la taille de tous les costumess chargés en %
    colorEffectValue = -1 + int( col * 0.01 * -16777215);
  }
  void changeGhostEffectBy(int a) {
    // change la taille de tous les costumess chargés en %
    gostEffectValue -= a;
    constrain(gostEffectValue, 0, 255);
  }
  void setGhostEffectTo(int a) {
    // change la taille de tous les costumess chargés en %
    gostEffectValue = 255 - a;
    constrain(gostEffectValue, 0, 255);
  }
  void clearGraphicEffects() {
    gostEffectValue = 255;
    colorEffectValue = -1;
  }

  //====================================== sensor =====================================================================================================================
 
  void setSpriteColorDetectionTo(boolean b) {
    spriteColorDetection = b;
  }
  void spriteColorDetector() { // scan les couleurs sous le lutin
    int l = costumes[costume].width/2;
    int h = costumes[costume].height/2;

    colorStored.clear(); //vide le tableau entre chaque frame      
    for (int i = 0; i < costumes[costume].width; i++) {
      for (int j = 0; j < costumes[costume].height; j++) {
        color  getColorSprite = costumes[costume].get(  int(i), int(j)  ); // récupère la couleur dont la zone est définie par la double FOR
        if (getColorSprite < 0) { // cherche uniquement dans la zone du sprite contenant de la couleur
          colorStored.append(  get (int (x + i - l), int ( y + j - h))); // stocke dans un tableau pour la boolean plus tard
        }
      }
    }
  }
  boolean touch(color col) { // boolean à appeler dans une condition pour la couleur
    if (colorStored.hasValue(col) ) { //si le tableau de couleur contient la couleur touchée.
      return true;
    } else {
      return false;
    }
  }
  boolean touch(float xx, float yy, float l, float h) { // hit box comparée entre 2 sprites
    if ( x + spriteWidth/2 > xx - l /2 &&
      x - spriteWidth/2 < xx + l/2 &&
      y + spriteHeight/2 > yy - h/2 &&
      y - spriteHeight/2 < yy + h/2 ) {
      return true;
    } else {
      return false;
    }
  }
  boolean touch(Sprite other) { // hit box comparée entre 2 sprites
    return touch(other.x, other.y, other.spriteWidth, other.spriteHeight);
  }
  boolean touch(String s) { // si touche le pointeur de souris
    // touche bords
    if (s == "edge" && ( x + spriteWidth/2 > width ||
      x - spriteWidth/2 < 0 ||
      y + spriteHeight/2 > height ||
      y - spriteHeight/2 < 0 )) {
      return true;
    }
    // touche souris
    else if (s == "mouse" &&  x + spriteWidth/2 > mouseX &&
      x - spriteWidth/2 < mouseX &&
      y + spriteHeight/2 > mouseY &&
      y - spriteWidth/2 < mouseY ) {
      return true;
    } else {
      return false;
    }
  }
  float distanceTo(String s) {
    if (s == "mouse") {
      return dist(x, y, mouseX, mouseY);
    } else {
      return 0;
    }
  }
  float distanceTo(Sprite o) {
    return dist(x, y, o.x, o.y);
  }
  //-----------TO DO ASK BLOCK------------------------------------------------------------------

  //--------------------------------------------------------------------------------------------
  void setDragMode(boolean drag) {
    dragable = drag;
  }
  void dragSprite() {
    if (dragable && mousePressed && touch("mouse")) {
      x = mouseX;
      y = mouseY;
    }
  }
  //-----------TO DO KEYISDOWN------------------------------------------------------------------

  //--------------------------------------------------------------------------------------------
}


//---Main fonction----



// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {    // If it's not a directory
    return null;
  }
}

//-------import sounds ---
SoundFile[] sounds; // array of sounds
int totalNumberOfSounds, loadedSound;
//-----------------------------------
//-----------TO DO loudness------------------------------------------------------------------

//--------------------------------------------------------------------------------------------

void soundFolder(String folder) {
  String path = sketchPath()+ "/data/" + folder; // search for folderpath
  String[] filenames = listFileNames(path); // search filenames

  for (int i = 0; i < filenames.length; i++) {
    String extention = filenames[i].substring(filenames[i].indexOf(".")); // separate extention for separate img to sounds and prevent otherfiles
    //sounds
    if (extention.equals(".wav") || extention.equals(".mp3") || extention.equals(".aiff") ) {
      totalNumberOfSounds ++; // same for sounds
    }
  }
  sounds = new SoundFile[totalNumberOfSounds]; // array of sound

  for (int i = 0; i < filenames.length; i++) {
    String extention = filenames[i].substring(filenames[i].indexOf("."));
    //sounds
    if (extention.equals(".wav") || extention.equals(".mp3") || extention.equals(".aiff") ) {
      sounds[loadedSound] =  new SoundFile(this, path +"/"+ filenames[i], false); // charge les costumes
      loadedSound++;
    }
  }
}

void playSound(int numeroSon) {
  sounds[numeroSon].play();
}
void stopSound(int numeroSon) {
  sounds[numeroSon].stop();
}


void pickColor() {
  println(get(mouseX, mouseY));
  push();
  textSize(16);
  fill(0, 255, 0);
  text(get(mouseX, mouseY), 20, 20);
  pop();
}


class Scene {

  PImage [] scene; // tableau pour stocker les différentes images du sprite
  int currentBackdrop = 0;

  Scene( String folder) { // choisir le nom du sprite, le nombre de costumes
    String path = sketchPath()+ "/data/" + folder; // search for folderpath
    String[] filenames = listFileNames(path); // search filenames
    printArray(filenames); // print names
    int totalNumberOfScenes = 0;
    int loadedScene = 0;
    for (int i = 0; i < filenames.length; i++) {
      String extention = filenames[i].substring(filenames[i].indexOf(".")); // separate extention for separate img to sounds and prevent otherfiles
      //images
      if (extention.equals(".png") || extention.equals(".jpg") || extention.equals(".jpeg") || extention.equals(".tga") || extention.equals(".gif") ) {
        totalNumberOfScenes++;   // var for knowing the number of images
      }
    }

    scene = new PImage [totalNumberOfScenes]; // array of images

    for (int i = 0; i < filenames.length; i++) {
      String extention = filenames[i].substring(filenames[i].indexOf("."));
      //images
      if (extention.equals(".png") || extention.equals(".jpg") || extention.equals(".jpeg") || extention.equals(".tga") || extention.equals(".gif") ) {
        scene[loadedScene] = loadImage(path +"/"+ filenames[i]); // charge les costumess
        scene[loadedScene].resize(width, height);
        loadedScene++;
      }
    }
  }

  void backdrops() {
    background(scene[currentBackdrop] );
  }
  void switchBackdropTo( int c) { // change le costumes du personnage
    currentBackdrop = c;
  }
  void nextBackdrop() { // change le costumes du personnage
    currentBackdrop++;
    currentBackdrop = currentBackdrop%scene.length;
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
