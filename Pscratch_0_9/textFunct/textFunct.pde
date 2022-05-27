private StringList   data = new StringList(); // initialise la liste pour les lettres du clavier
private String answer = "";  // la phrase de chat.
private String charKey; // variable pour convertir le clavier en texte
private String textScreen = "";  // la phrase de chat.
public boolean isAsking;

void setup()
{
  size(480, 600); //taille de l'écran
  ask("sdgf");
}

void mousePressed() {
  // ask();
}

void draw() {

  background(0100); // fond d'application
  textToScreen(); // appel la fonction ci-dessous
  println(answer);
}

void ask(String s) {
  if (!isAsking) {
    isAsking = true;
    says(s);
  }
}

void textToScreen() { // créer une fonction appelée ici dans la draw au dessus
  if (isAsking) {
    push(); // parenthèse de filtres et de mouvement
    fill (255); // colorie l'objet suivant
    strokeWeight(2);
    rect (0, height - 40, width-2, 40); // rectangle
    fill (0);
    textSize(16);
    text (textScreen, 10, height - 15); // texte à l'écran
    fill(0, 100, 255);
    circle(width - 20, height - 20, 24);
    pop(); //fin de parenthèse de filtres et de mouvement
    if (dist(mouseX, mouseY, width - 20, height - 20) < 24 && mousePressed) {
      answer = textScreen;
      textScreen = "";
      data.clear();
      isAsking = false;
    }
  }
}


void keyType() {
  if (isAsking) {
    if (key == BACKSPACE  ) {  // condition si la touche effacée est appuyé pour éviter les ?? charactères
      if ( data.size() > 0)  data.remove(data.size()-1); // efface la dernière touche enregistrée
    } else { // sinon (condition inverse)
      if (key != CODED ) { // éviter les ?? charactères
        charKey = Character.toString(key);  //transforme le charactère en string (texte)
        data.append(charKey); // rajoute le charactère converti en string a la liste
      }
    }
    textScreen = join(data.array(), ""); // rassemble la liste en un seul bloc texte (string)

    if (key == ENTER) { // si on appuye sur ENTER
      if ( data.size() > 0)  data.remove(data.size()-1); // efface la dernière touche enregistrée
      textScreen = join(data.array(), ""); // rassemble la liste en un seul bloc texte (string)
      answer = textScreen;
      textScreen = "";
      data.clear();
      isAsking = false;
    }
  }
}




void keyPressed() {              // called when a key is pressed
  key();
}
