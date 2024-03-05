package R2mix.PScratch;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

import processing.core.*;
//====================================================================== SCENE =================================================================================
import processing.data.StringList;

public class Stage {
  public PApplet myParent;
  public final static String VERSION = "PScratch-1.0.0 by R2MIX", WEBSITE = "https://github.com/r2mix/pscratch";

  // similare to sprite class but more light
  // -----------ASK
  // BLOCK------------------------------------------------------------------
  private StringList data = new StringList(); // list for storing inputkeys
  public String answer = ""; // Return the answer to the user
  private String charKey; // converting char in string
  private String textScreen = ""; // Show typed on the screen
  public boolean isAsking; // check if the question is asked

  private void textToScreen() {
    if (isAsking) {
      myParent.push();
      myParent.fill(255);
      myParent.strokeWeight(2);
      myParent.rect(0, myParent.height - 40, myParent.width - 2, 40); // white rectangle on the screen
      myParent.fill(0);
      myParent.textSize(16);
      myParent.text(textScreen, 10, myParent.height - 15); // text in black
      myParent.fill(0, 100, 255);
      myParent.circle(myParent.width - 20, myParent.height - 20, 24);
      myParent.pop();
      if (PApplet.dist(myParent.mouseX, myParent.mouseY, myParent.width - 20, myParent.height - 20) < 24 && myParent.mousePressed) { // button or return for submit and reset
                                                                                // all
        answer = textScreen;
        textScreen = "";
        data.clear();
        isAsking = false;
      }
    }
  }

  private void keyType() {
    if (isAsking) {
      if (myParent.key == PConstants.BACKSPACE) { // erase function
        if (data.size() > 0)
          data.remove(data.size() - 1);
      } else {
        if (myParent.key != PConstants.CODED) { // avoid ?? char
          charKey = Character.toString(myParent.key); // convert key to string (texte)
          data.append(charKey); // add to data
        }
      }
      textScreen = PApplet.join(data.array(), ""); // join the array in a single string

      if (myParent.key == PConstants.ENTER) { // send answer and reset
        if (data.size() > 0)
          data.remove(data.size() - 1); // avoir blank line caused by enter  toArray
        textScreen = PApplet.join(data.array(), "");
        answer = textScreen;
        textScreen = "";
        data.clear();
        isAsking = false;
      }
    }
  }
  // --------------------------------------------------------------------------------------------------------------------

  // ----------------------------------------------------------KEYISDOWN------------------------------------------------------------------
  public ArrayList<Character> keyStored = new ArrayList<Character>(); // for qwerty key
  public ArrayList<Integer> keyStoredCoded = new ArrayList<Integer>(); // for coded key as arrow...
 
  public boolean keyIsPressed(char k) { // call this boolean for interact width key

    if (keyStored.contains(k)) { // if array contain the letter of the keyBoard
      return true;
    } else {
      return false;
    }
  }

  public boolean keyIsPressed(String k) { // call this boolean for interact width keycoded

    if (k == "upArrow" && keyStoredCoded.contains(38)) { // if array contain the keycod of the keyBoard
      return true;
    } else if (k == "leftArrow" && keyStoredCoded.contains(37)) {
      return true;
    } else if (k == "rightArrow" && keyStoredCoded.contains(39)) {
      return true;
    } else if (k == "downArrow" && keyStoredCoded.contains(40)) {
      return true;
    } else {
      return false;
    }
  }

  public void keyIsDown() {                                                    //call it into keyPressed void
    keyType();
    if (!isAsking) {                                                           // disable key when asking
      if (!keyStored.contains(myParent.key) && myParent.key != PConstants.CODED) keyStored.add(myParent.key);        // store in array if not already and not coded, different array for coded
      if (!keyStoredCoded.contains((int)(myParent.keyCode)) && myParent.key == PConstants.CODED) keyStoredCoded.add((int)(myParent.keyCode));
    }
  }

  public void keyIsUp() {                                                      //call it into keyReleased void and remove from arrays
    if (keyStored.contains(myParent.key) && myParent.key != PConstants.CODED) keyStored.remove(keyStored.indexOf(myParent.key));
    if (keyStoredCoded.contains((int)(myParent.keyCode)) && myParent.key == PConstants.CODED) keyStoredCoded.remove(keyStoredCoded.indexOf((int)(myParent.keyCode)));
  }

  
  // -----------------------------------------------------------END of
  // KEY----------------------------------------------------------------------

  // ---------------------------------------------------------- clone system
  // -------------------------------------------------------------------
  public void drawClones(ArrayList<? extends Sprite> clones) {
    for (int i = clones.size() - 1; i >= 0; i--) {
      clones.get(i).draw(); // call la méthode "draw" de l'interface
    }
  }
  // ---------------------------------------------------------- END clone system
  // ----------------------------------------------------------------

  public void Wait(float time) {                                             // wait in sec to millis
    myParent.delay((int)(time * 1000));
  }
 
  public void Play() {
    myParent.loop();
  }

  public void Pause() {
    myParent.noLoop();
  }

  public void pick() {                                                   // call it if you want to get the color of a pixel with you mouse when you click
    if (myParent.mousePressed)PApplet.println("color : #" + PApplet.hex(myParent.get(myParent.mouseX, myParent.mouseY)), "mouseX : "+ myParent.mouseX, "mouseY : " + myParent.mouseY, "width : " + myParent.width, "height : " + myParent.height, "frameRate : " + (int)(myParent.frameRate ));
  }

  private long previousMillis = 0;
  public float timer;

  public void timer() {
    timer = (float) ((myParent.millis() - previousMillis) * 0.001);
  }

  public void resetTimer() {
    previousMillis = myParent.millis();
  }

  // -------------------------------------------------------- directoryFiles
  // ------------------------------------------------------------------
  public HashMap<String, PImage[]> allAssetImages; // storing all arrays inside a dictionary
  public boolean printFolder = true;

  public void printFolder() { // Have to be called before stagefolder for print informations
    printFolder = true;
  }

  // This function returns all the files in a directory as an array of Strings
  private String[] listFileNames(String dir) { // called in sprite class, scene class and sound void
    File file = new File(dir);
    if (file.isDirectory()) {
      String names[] = file.list();
      return names;
    } else { // If it's not a directory
      return null;
    }
  }

  public PImage[] spriteFolder(String folder) { // verify how many items arent images and import them
    PImage[] costumes = null;
    try {
      String path = myParent.sketchPath()+ "/data/" + folder; // search for folderpath
      String[] filenames = listFileNames(path); // search filenames
      java.util.Arrays.sort(filenames); // Sorts all files by name
      if (printFolder)
        PApplet.println(folder + " images : "); // print names
      if (printFolder)
        PApplet.printArray(filenames);
      int totalNumberOfCostumes = 0;
      int loadedCostume = 0;
      for (int i = 0; i < filenames.length; i++) { // iterate for searching each file and check if it's an image before
                                                   // importing them
        String extention = filenames[i].substring(filenames[i].lastIndexOf(".")); // separate extention for separate img to
                                                                              // sounds and prevent otherfiles
        if (extention.equals(".png") || extention.equals(".jpg") 
            || extention.equals(".jpeg")|| extention.equals(".tga") 
            || extention.equals(".gif") || extention.equals(".PNG") 
            || extention.equals(".JPG") || extention.equals(".JPEG")
            || extention.equals(".TGA") || extention.equals(".GIT")) {
          totalNumberOfCostumes++; // var for knowing the number of images
        }
      }
      costumes = new PImage[totalNumberOfCostumes]; // init the array of images width the checked up
                                                    // totalNumberOfCostumes var
      for (int i = 0; i < filenames.length; i++) { // iterate for importing them
        String extention = filenames[i].substring(filenames[i].lastIndexOf(".")); // check extention prevent fail
        if (extention.equals(".png") || extention.equals(".jpg") 
            || extention.equals(".jpeg")|| extention.equals(".tga") 
            || extention.equals(".gif") || extention.equals(".PNG") 
            || extention.equals(".JPG") || extention.equals(".JPEG")
            || extention.equals(".TGA") || extention.equals(".GIT")) {
          costumes[loadedCostume] = myParent.loadImage(path + "/" + filenames[i]); // load images
          loadedCostume++;
        }
      }
    } catch (Exception e) {
      PApplet.println("!!---- Caution ! There is no spriteFolder at this name : " + folder + " ----!!");
    }
    if (costumes.length < 1) {
      PApplet.println("!!---- Caution ! spriteFolder : " + folder + " empty ----!!");
    }
    return costumes;
  }

  // ---------------------------------------------------------------------------------------------------------------------------------------------
  // ================================================================ END MAIN
  // FUNCTIONS
  // ==========================================================================

  private PImage[] stage;
  public int backdrop = 0;
  public int colorEffectValue = 0;
  public int ghostEffectValue = 255;

  public Stage(PApplet theParent, String folder) {
    myParent = theParent;
    PApplet.println(VERSION);
    PApplet.println(WEBSITE);
    String dossierPrincipal = myParent.sketchPath() + "/data/";
    File dossier = new File(dossierPrincipal);
    File[] sousDossiers = dossier.listFiles();
    allAssetImages = new HashMap<String, PImage[]>();
    for (int i = 0; i < sousDossiers.length; i++) {
      File sousDossier = sousDossiers[i];
      if (sousDossier.isDirectory()) {
        String nomSousDossier = sousDossier.getName();
        PImage[] tableauImages = spriteFolder(nomSousDossier);
        allAssetImages.put(nomSousDossier, tableauImages);
      }
    }
    stage = allAssetImages.get(folder);
    for (int i = 0; i < stage.length; i++) {
      stage[i].resize(myParent.width, myParent.height);
    }
  }

  // alternate stage with a subfolder specification
  public Stage(PApplet theParent, String folder, String subFolder) {
    myParent = theParent;
    String dossierPrincipal = myParent.sketchPath() + "/data/" + subFolder + "/";
    File dossier = new File(dossierPrincipal);
    File[] sousDossiers = dossier.listFiles();
    allAssetImages = new HashMap<String, PImage[]>();
    for (int i = 0; i < sousDossiers.length; i++) {
      File sousDossier = sousDossiers[i];
      if (sousDossier.isDirectory()) {
        String nomSousDossier = sousDossier.getName();
        PImage[] tableauImages = spriteFolder(subFolder + "/" +nomSousDossier);
        allAssetImages.put(nomSousDossier, tableauImages);
      }
    }
    stage = allAssetImages.get(folder);
    for (int i = 0; i < stage.length; i++) {
      stage[i].resize(myParent.width, myParent.height);
    }
  }

  public void backdrops() { // call it in top of draw for being behing everything
    timer(); // for the timer
    myParent.push();
    myParent.tint(255, ghostEffectValue);
    myParent.image(stage[backdrop], 0, 0, myParent.width, myParent.height);
      if (colorEffectValue > 0) {
        colorEffectTint(colorEffectValue);
        myParent.image(stage[backdrop], 0, 0, myParent.width, myParent.height);
      }
    myParent.pop();
    textToScreen();
  }

  // -------------------------------------------------------------- looks function
  // similare to sprite
  // --------------------------------------------------------------

  public void switchBackdropTo(int c) {
    backdrop = c;
  }

  public void nextBackdrop() {
    backdrop++;
    backdrop = backdrop % stage.length;
  }

  private void colorEffectTint(int valColor) {
    valColor = valColor%360; // limit to 360 for a circle of color
    int redValue = (int)(128 + 127 * PApplet.cos(PApplet.radians(valColor)));
    int greenValue = (int)(128 + 127 * PApplet.cos(PApplet.radians(valColor - 120)));
    int blueValue = (int)(128 + 127 * PApplet.cos(PApplet.radians(valColor - 240)));
    int currentColor = myParent.color(redValue, greenValue, blueValue); // set de current color
    myParent.tint(currentColor, PApplet.constrain(valColor * 5 * ghostEffectValue/255, 0, 360)); // apply to the image
  }

  public void changeColorEffectBy(int col) {
    colorEffectValue += col;
  }

  public void setColorEffectTo(int col) {
    colorEffectValue = col;
  }

  public void changeGhostEffectBy(int a) {
    ghostEffectValue -= a;
    PApplet.constrain(ghostEffectValue, 0, 255);
  }

  public void setGhostEffectTo(int a) {
    ghostEffectValue = 255 - a;
    PApplet.constrain(ghostEffectValue, 0, 255);
  }

  public void clearGraphicEffects() {
    ghostEffectValue = 255;
    colorEffectValue = 0;
  }
}
// =================================================================== END SCENE
// ================================================================================
