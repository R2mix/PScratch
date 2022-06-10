import processing.sound.*;                  //sound lib

public class Sprite extends Thread {

  public float x, y, direction, angleRadian, spriteWidth, spriteHeight; // basics informations of the sprite
  public  int costume, spriteSize = 100, sens=1;                        // actual costume and size of the sprite
  public color colorEffectValue = -1;                                   // defaut color effect value (no coloration)
  public color gostEffectValue = 255;                                   // defaut ghost effect value (visible)
  private boolean  dragable, display = true, printFolder;               // boolean for rotation, dragable and is displaying, (private) call it by the named functions
  private IntList colorStored = new IntList();                          // list for storing color during the calculation                                        // list for storing color during the calculation
  public boolean spriteColorDetection = true;                           // enable/disable color scaning in case of high cpu/gpu usage (especially big sprites),
  // |---> warning : this disable the posibility of touching color with this sprite
  private PImage [] costumes;                                           // costumes is an array of images
  private String rotationStyle = "all around";

  public Sprite( ) {                                                    // initialize the sprite
    x = width/2;                                                        // default position
    y = height/2;
  }

  public Sprite(String file ) {                                         // initialize the sprite with only one costume
    x = width/2;
    y = height/2;
    costumes = new PImage [1];
    costumes[0] = loadImage(file);
  }

  //====================================== Sprite folder research =========================================================================================
  public void printFolder() {                                           // Have to be called before spriteFolder for print informations
    printFolder = true;
  }

  public void spriteFolder(String folder) {
    try {
      String path = sketchPath()+ "/data/" + folder;                      // search for folderpath
      String[] filenames = listFileNames(path);                           // search filenames
      java.util.Arrays.sort(filenames);                                   //Sorts all files by name
      if (printFolder) println(folder + " images : ");                    // print names
      if (printFolder) printArray(filenames);
      int totalNumberOfCostumes = 0;
      int loadedCostume = 0;
      for (int i = 0; i < filenames.length; i++) {                        // iterate for searching each file and check if it's an image before importing them
        String extention = filenames[i].substring(filenames[i].indexOf(".")); // separate extention for separate img to sounds and prevent otherfiles
        if (extention.equals(".png") || extention.equals(".jpg") || extention.equals(".jpeg") || extention.equals(".tga") || extention.equals(".gif") ) {
          totalNumberOfCostumes++;                                        // var for knowing the number of images
        }
      }
      costumes = new PImage [totalNumberOfCostumes];                      // init the array of images width the checked up totalNumberOfCostumes var
      for (int i = 0; i < filenames.length; i++) {                        // iterate for importing them
        String extention = filenames[i].substring(filenames[i].indexOf(".")); // check extention prevent fail
        if (extention.equals(".png") || extention.equals(".jpg") || extention.equals(".jpeg") || extention.equals(".tga") || extention.equals(".gif") ) {
          costumes[loadedCostume] = loadImage(path +"/"+ filenames[i]);   // load images
          loadedCostume++;
        }
      }
    }
    catch(Exception e) {
      println("!!---- Caution ! There is no spriteFolder at this name : " +folder+" ----!!");
      exit();
    }
    if (costumes.length < 1) {
      println("!!---- Caution ! spriteFolder : "+folder+ " empty ----!!");
      exit();
    }
  }

  //====================================== Show sprite and main sprite functions ==================================================================

  public void display() {

    spriteWidth = costumes[costume].width * spriteSize * 0.01;          // set the spriteWidth to the actual costume image
    spriteHeight = costumes[costume].height * spriteSize * 0.01;        // set the spriteHeight to the actual costume image
    //-------------------------- start style and transformations------------------------------------------------------------
    push();
    if (spriteColorDetection && display) spriteColorDetector();         // detect the bg color this is why is before image and need to be in draw not in a thread
    translate(x, y);                                                    // move to x and y, using translate cause rotation
    push();                                                             // double push for prevent reverse dialog
    rotationStyle();                                                    // rotate for orientation of the sprite
    scale(spriteSize *0.01 * sens, spriteSize * 0.01 );                 // scale when change size and left right orientation
    tint(colorEffectValue, gostEffectValue);                            // color and ghost effect
    imageMode(CENTER);                                                  // center the image like scratch does
    if (display)image(costumes[costume], 0, 0 );                        // showing the image (can be hiding and disable the color detection)
    pop();
    spriteSay();                                                        // void for speaking of thinking are permantly checking is somthing to think/say
    spriteThink();                                                      // need to be here in case of using say in a thread and not in draw
    pop();
    //-------------------------- end style and transformations------------------------------------------------------------
    dragSprite();                                                       // if the function dragable is called, sprite go to mouse when it's pressed
  }

  //====================================== Motion =====================================================================================================================

  public void move(float a) {
    x += cos(angleRadian) * a;                                          // trigonometric calcul for go to the angle of the direction of the sprite
    y += sin(angleRadian) * a;
  }
  public void turnRight(float a) {
    direction += a;
    direction = direction%360;                                          // rotation with reset on 360 degree then converted in radian
    angleRadian = radians(direction);
  }
  public void turnLeft(float a) {
    direction -= a;
    direction = direction%-360;
    angleRadian = radians(direction);
  }
  public void goTo(String s) {
    if (s == "mouse") {
      x = mouseX;
      y = mouseY;
    }
    if (s == "randomPosition") {
      x = random(width);
      y = random(height);
    }
  }
  public void goTo(Sprite o) {
    x = o.x;
    y = o.y;
  }
  public void goTo(float xx, float yy) {
    x = xx;
    y = yy;
  }
  public void pointInDirection(float a) {
    direction = a;
    angleRadian = radians(direction);
  }
  public  void pointTowards(float xx, float yy) {
    angleRadian = atan2(yy - y, xx - x);     // transform a matrix of position to an angle (in radians)
    direction = degrees(angleRadian);
  }
  public void pointTowards(String mouseIn) {
    if (mouseIn == "mouse")angleRadian = atan2(mouseY - y, mouseX - x);
    direction = degrees(angleRadian);
  }
  public void pointTowards(Sprite o) {
    angleRadian = atan2(o.y - y, o.x - x);
    direction = degrees(angleRadian);
  }

  //---------------------------------------glide system, better call it in run void ---------------------------------------------------
  private float startX, startY;                                            // start position
  private boolean isGliding;                                               // statement

  public void glide(float time, float  xx, float yy) {                     // time in sec of gliding and end positions
    if (!isGliding) {                                                      // init before gliding
      startX = x;
      startY = y;
      isGliding = true;
    }
    int frac = int( (time * 1000)/16);                                     // time calculation

    for (int i = 0; i < frac; i++) {                                       // move for each 16 millisecond to the end position
      x += (xx - startX)/(frac);
      y += (yy - startY)/(frac);
      delay(16);
    }
    isGliding = false;                                                     // end of gliding
    x = xx;                                                                // repositionate in case of float number.
    y=yy;
  }
  //------------------------------------------------- END glide system--- ---------------------------------------------------------

  public  void glide(float t, String txt) {                                // glide ton mouse or random, also better call it in run void
    if (txt == "randomPosition") {
      glide(t, random(width), random(height));
    }
    if (txt == "mouse") {
      glide(t, mouseX, mouseY);
    }
  }
  public void glide(float t, Sprite o) {                                   // glide to sprite, also better call it in run void
    glide(t, o.x, o.y);
  }

  public  void changeXBy(float add) {
    x += add;
  }
  public void setXTo(float a) {
    x = a;
  }
  public void changeYBy(float add) {
    y += add;
  }
  public  void setYTo(float a) {
    y = a;
  }
  public void ifOnEdgeBounce() {                                           // bounce on edge of the screen
    if ( x+ spriteWidth/2 > width) pointInDirection(180 - direction);
    if (x - spriteWidth/2 < 0) pointInDirection(180 - direction);
    if (y + spriteHeight/2 > height) pointInDirection(direction * -1);
    if (y - spriteHeight/2 < 0) pointInDirection(direction * -1);
    direction = direction%-360;
  }
  public void setRotationStyle(String rs) {                                // fixe rotation to none
    rotationStyle = rs;
  }

  private void rotationStyle() {                                           // fixe rotation to none
    if (rotationStyle == "left-right") {
      if (direction >= 0 && direction <=90) {
        sens = 1;
      } else if (direction >= -90 && direction <=0) {
        sens = 1;
      } else {
        sens = -1;
      }
    }
    if (rotationStyle == "don't rotate") {
      sens = 1;
    }
    if (rotationStyle == "all around") {
      rotate(angleRadian);
      sens = 1;
    }
  }

  //====================================== Looks =====================================================================================================================

  private String spriteSays, spriteThinks;                                 // sprite always have a things to say of thing, they are speaky

  public void spriteSay() {
    if (spriteSays != null && spriteSays.length() > 0) {                   // only display if something is written
      push();
      fill(255);
      noStroke();
      int bubbleSize = 12;
      if (spriteSays.length() > 12) bubbleSize = spriteSays.length();
      rect( 0, - (spriteHeight/2) - 48, bubbleSize * 11, 48, 48); // bubble
      triangle((spriteWidth/2)+16, - spriteHeight/2, spriteWidth/3, -spriteHeight/4, spriteWidth/2, -spriteHeight/2 ); // quote
      fill(0);
      textSize(16);
      text(spriteSays, 20, - (spriteHeight/2) - 24);
      pop();
    }
  }

  public void say(String txt) {
    spriteSays = txt;
  }
  public void say(String txt, float time) {                                 // only use in a thread !!! or block the entire project
    say(txt);
    delay(int (time * 1000));                                               // add time then converted into miliseconds
    spriteSays = null;                                                      // set to null for hidding dialog
  }

  public void spriteThink() {                                               // as say but for thinking
    if (spriteThinks != null && spriteThinks.length() > 0) {
      push();
      fill(255);
      noStroke();
      int bubbleSize = 12;
      if (spriteThinks.length() > 12) bubbleSize = spriteThinks.length();
      rect( 0, - (spriteHeight/2) - 48, bubbleSize * 11, 48, 48);// bubble
      circle( (spriteWidth/2)+16, - spriteHeight/2, spriteWidth/8);
      circle( (spriteWidth/3)+16, - spriteHeight/3, spriteWidth/8);
      fill(0);
      textSize(16);
      text(spriteThinks, 20, - (spriteHeight/2) - 24);
      pop();
    }
  }

  public void think (String txt) {
    spriteThinks = txt;
  }
  public void think(String txt, float time) {
    think(txt);
    delay(int (time * 1000));
    spriteThinks = null;
  }
  public void switchCostumeTo( int c) {
    costume = c;
  }
  public void nextCostume() {
    costume++;
    costume = costume%costumes.length;                                       // loop costume to 0 is longer than max costume
  }
  public void changeSizeBy(int t) {                                          // for all costumes
    spriteSize += t;
    if (spriteSize < 1) spriteSize = 1;                                      //prevent 0
  }
  public void setSizeTo(int t) {
    spriteSize = t;
    if (spriteSize < 1) spriteSize = 1;
  }
  public void changeColorEffectBy(float col) {
    colorEffectValue -= col * 0.01 * 16777215;                               // change color in binary to max 0 to 100
  }
  public void setColorEffectTo(float col) {
    colorEffectValue = -1 + int( col * 0.01 * -16777215);                    // set color in binary to 0 to 100
  }
  public void changeGhostEffectBy(int a) {
    gostEffectValue -= a;
    constrain(gostEffectValue, 0, 255);                                      // prevent lower of higher value
  }
  public void setGhostEffectTo(int a) {
    gostEffectValue = 255 - a;
    constrain(gostEffectValue, 0, 255);
  }
  public void clearGraphicEffects() {                                        // restore default values
    gostEffectValue = 255;
    colorEffectValue = -1;
  }
  public void show() {                                                       // displaying the sprite
    display= true;
  }
  public void hide() {                                                       // hidding the sprite
    display = false;
  }

  //====================================== sensor =====================================================================================================

  public void setSpriteColorDetectionTo(boolean b) {                         // enable/disable color detection for high CPU/GPU usage
    spriteColorDetection = b;
  }
  //----------- detect colors behind the sprite and compare it to colors of the sprite and return if both are correct, dont call this fonction-----------
  private void spriteColorDetector() {
    int l = int(spriteWidth);
    int h = int(spriteHeight);
    colorStored.clear();                                                     //reset the color of the sprite
    for (int i = 0; i < l; i++) {
      for (int j = 0; j < h; j++) {                                          // for only if the sprite has a color at this point
        colorStored.append(  get (int (x + i - l/2), int ( y + j - h/2)));
      }
    }
  }
  //------------------------------------------------------------- END of color detection------------------------------------------------------------------
  public boolean touch(color col) {                                         // call this boolean for testing if touching color
    if (colorStored.hasValue(col) ) {                                       // if the color is present into the list of colors stored
      return true;
    } else {
      return false;
    }
  }
  public boolean touch(float xx, float yy, float l, float h) {              // square hitbox comparing two position and size
    if ( x + spriteWidth/2 > xx - l /2 &&
      x - spriteWidth/2 < xx + l/2 &&
      y + spriteHeight/2 > yy - h/2 &&
      y - spriteHeight/2 < yy + h/2 ) {
      return true;
    } else {
      return false;
    }
  }
  public boolean touch(Sprite other) {                                      // square hitbox comparing to a sprite
    return touch(other.x, other.y, other.spriteWidth, other.spriteHeight);
  }
  public boolean touch(String s) {                                          // square hitbox comparing to :
    // touch edge
    if (s == "edge" && ( x + spriteWidth/2 > width ||
      x - spriteWidth/2 < 0 ||
      y + spriteHeight/2 > height ||
      y - spriteHeight/2 < 0 )) {
      return true;
    }
    // touch mouse
    else if (s == "mouse" &&  x + spriteWidth/2 > mouseX &&
      x - spriteWidth/2 < mouseX &&
      y + spriteHeight/2 > mouseY &&
      y - spriteWidth/2 < mouseY ) {
      return true;
    } else {
      return false;
    }
  }
  public float distanceTo(String s) {                                        // get the distance to mouse or a sprite, position
    if (s == "mouse") {
      return dist(x, y, mouseX, mouseY);
    } else {
      return 0;                                                              //if string is not mouse, prevent null
    }
  }
  public float distanceTo(Sprite o) {
    return dist(x, y, o.x, o.y);
  }
  public float distanceTo(float xx, float yy) {
    return dist(x, y, xx, yy);
  }


  public void setDragMode(boolean drag) {                                    // call it for enable or disable if the sprite is dragable, dont use the boolean only this void
    dragable = drag;
  }

  private void dragSprite() {                                                // don't call it is automatique if you enable with the setDrageMode void
    if (dragable && mousePressed && touch("mouse")) {
      x = mouseX;
      y = mouseY;
    }
  }

  //-----------ASK BLOCK------------------------------------------------------------------
  void ask(String s) {                                                       // ask block is a stage function but each sprite call it by this function.
    if (!isAsking) {
      isAsking = true;
      say(s);                                                                // display the question
    }
  }
  //--------------------------------------------------------------------------------------------
}


//========================================================================= END OF SPRITE CLASS ================================================================

//--------------------------------------------------------------------------------------------------------------------------------------------------------------

//================================================================== MAIN FUNCTIONS ============================================================================

//-----------ASK BLOCK------------------------------------------------------------------
private StringList   data = new StringList();                                 // list for storing inputkeys
public String answer = "";                                                    // Return the answer to the user
private String charKey;                                                       // converting char in string
private String textScreen = "";                                               // Show typed on the screen
public boolean isAsking;                                                     // check if the question is asked

private void textToScreen() {
  if (isAsking) {
    push();
    fill(255);
    strokeWeight(2);
    rect (0, height - 40, width-2, 40);                                       // white rectangle on the screen
    fill (0);
    textSize(16);
    text (textScreen, 10, height - 15);                                       // text in black
    fill(0, 100, 255);
    circle(width - 20, height - 20, 24);
    pop();
    if (dist(mouseX, mouseY, width - 20, height - 20) < 24 && mousePressed) { // button or return for submit and reset all
      answer = textScreen;
      textScreen = "";
      data.clear();
      isAsking = false;
    }
  }
}

private void keyType() {
  if (isAsking) {
    if (key == BACKSPACE  ) {                                                 // erase function
      if ( data.size() > 0)  data.remove(data.size()-1);
    } else {
      if (key != CODED ) {                                                    // avoid ?? char
        charKey = Character.toString(key);                                    //convert key to string (texte)
        data.append(charKey);                                                 // add to data
      }
    }
    textScreen = join(data.array(), "");                                      // join the array in a single string

    if (key == ENTER) {                                                       // send answer and reset
      if ( data.size() > 0)  data.remove(data.size()-1);                      // avoir blank line caused by enter
      textScreen = join(data.array(), "");
      answer = textScreen;
      textScreen = "";
      data.clear();
      isAsking = false;
    }
  }
}
//--------------------------------------------------------------------------------------------------------------------



//----------------------------------------------------------KEYISDOWN------------------------------------------------------------------
private ArrayList<Character> keyStored = new ArrayList<Character>();         // for qwerty key
private ArrayList<Integer> keyStoredCoded = new ArrayList<Integer>();        // for coded key as arrow...
public void keyIsDown() {                                                    //call it into keyPressed void
  keyType();
  if (!isAsking) {                                                           // disable key when asking
    if (!keyStored.contains(key) && key != CODED) keyStored.add(key);        // store in array if not already and not coded, different array for coded
    if (!keyStoredCoded.contains(int(keyCode)) && key == CODED) keyStoredCoded.add(int(keyCode));
  }
}
public void keyIsUp() {                                                      //call it into keyReleased void and remove from arrays
  if (keyStored.contains(key) && key != CODED) keyStored.remove(keyStored.indexOf(key));
  if (keyStoredCoded.contains(int(keyCode)) && key == CODED) keyStoredCoded.remove(keyStoredCoded.indexOf(int(keyCode)));
}

public boolean keyIsPressed(char k) {                                        // call this boolean for interact width key

  if (keyStored.contains(k)) {                                               // if array contain the letter of the keyBoard
    return true;
  } else {
    return false;
  }
}
public boolean keyIsPressed(String k) {                                     // call this boolean for interact width keycoded

  if (k == "upArrow" && keyStoredCoded.contains(38) ) {                     // if array contain the keycod of the keyBoard
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
//-----------------------------------------------------------END of KEY-------------------------------------------------------------------



public void Wait(float time) {                                             // wait in sec to millis
  delay(int(time * 1000));
}

// This function returns all the files in a directory as an array of Strings
private String[] listFileNames(String dir) {                               // called in sprite class, scene class and sound void
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {                                                                 // If it's not a directory
    return null;
  }
}

//--------------------------------------------------------import sounds ---------------------------------------------------------------------
private SoundFile[] sounds;                                                // array of sounds look in sprite and work the same but with sounds
private int totalNumberOfSounds, loadedSound;
private AudioIn input;
private Amplitude amplitude;
public int loudness;
public boolean openMic;
//private float pitch = 1, volume = 1, pan = 0;                                //defaut sounds values
private float[] pitch, volume, pan;

public void soundFolder(String folder) {
  try {
    String path = sketchPath()+ "/data/" + folder;
    String[] filenames = listFileNames(path);
    java.util.Arrays.sort(filenames);
    println(folder + " sounds : ");
    printArray(filenames);
    for (int i = 0; i < filenames.length; i++) {
      String extention = filenames[i].substring(filenames[i].indexOf("."));
      if (extention.equals(".wav") || extention.equals(".mp3") || extention.equals(".aiff") ) {
        totalNumberOfSounds ++;
      }
    }
    sounds = new SoundFile[totalNumberOfSounds];
    pitch = new float[totalNumberOfSounds];
    volume = new float[totalNumberOfSounds];
    pan = new float[totalNumberOfSounds];

    for (int i = 0; i < filenames.length; i++) {
      String extention = filenames[i].substring(filenames[i].indexOf("."));
      if (extention.equals(".wav") || extention.equals(".mp3") || extention.equals(".aiff") ) {
        sounds[loadedSound] =  new SoundFile(this, path +"/"+ filenames[i], false);
        loadedSound++;
      }
    }
  }
  catch(Exception e) {
    println("!!---- Caution ! There is no SoundFolder at this name : " +folder+" ----!!");
    exit();
  }
  openMicrophone();
  clearSoundEffects();
}
//-----------------------------------------------------END import sounds ---------------------------------------------------------------------

void openMicrophone() {                                                       // call it inside setup void
  try {
    input = new AudioIn(this, 0);                                               // new default mic
    input.start();                                                              // start mic
    amplitude = new Amplitude(this);                                            // new analyser
    amplitude.input(input);                                                     // attach input to analyzer
    openMic = true;
  }
  catch(Exception e) {
    openMic = false;
    println("---!! no microphone detected  !!---");
  }
}
void microphone() {                                                            // call it inside draw void
  if (openMic) {
    loudness = int(amplitude.analyze() * 100);                                  // analyze the sound and convert to 100
  }
}

//--------------------------------------------------------------------------------------------

public void playSound(int numeroSon) {                                       // play a sound from 0 with pitch[i] value and volume value
  sounds[numeroSon].play(pitch[numeroSon], volume[numeroSon] );
  if (sounds[numeroSon].channels() == 1) sounds[numeroSon].pan(pan[numeroSon]);
}
public void playSoundUntilDown(int numeroSon) {                              //wait the sound is over before go to the next code ling, better using is into run void
  playSound( numeroSon);
  while ( sounds[numeroSon].isPlaying() && sounds[numeroSon].percent() < 100 );
  sounds[numeroSon].stop();
}
public void stopSound(int numeroSon) {                                       // stop a sound
  sounds[numeroSon].stop();
}
public void stopAllSound() {                                                 // stop all sounds
  for (int i =0; i < totalNumberOfSounds; i++) {
    sounds[i].stop();
  }
}
public void changePitchEffectBy(float p) {                                   // change pitch[i] of a sound by changing it rate (like on scratch)
  for (int i =0; i < totalNumberOfSounds; i++) {
    pitch[i] += p * 0.01;
    pitch[i] = constrain(pitch[i], 0, 100);
    sounds[i].rate(pitch[i]);
  }
}
public void setPitchEffectTo(float p) {
  for (int i =0; i < totalNumberOfSounds; i++) {
    pitch[i] = p * 0.01;
    pitch[i] = constrain(pitch[i], 0, 100);
    sounds[i].rate(pitch[i]);
  }
}
public void changePanEffectBy(float pa) {                                    // -1 left, +1 right 0 center (don't work with stereo sounds)
  for (int i =0; i < totalNumberOfSounds; i++) {
    pan[i] += (pa * 0.01);
    pan[i] = constrain(pan[i], -1, 1);
    if (sounds[i].channels() == 1) sounds[i].pan(pan[i]);
  }
}
public void setPanEffectTo(float pa) {
  for (int i =0; i < totalNumberOfSounds; i++) {
    pan[i] = pa * 0.01;
    pan[i] = constrain(pan[i], -1, 1);
    if (sounds[i].channels() == 1) sounds[i].pan(pan[i]);
  }
}
public void changePitchEffectBy(float p, int s) {                            // change pitch[i] of a sound by changing it rate (like on scratch)
  pitch[s] += p * 0.01;
  pitch[s] = constrain(pitch[s], 0, 100);
  sounds[s].rate(pitch[s]);
}
public void setPitchEffectTo(float p, int s) {
  pitch[s] = p * 0.01;
  pitch[s] = constrain(pitch[s], 0, 100);
  sounds[s].rate(pitch[s]);
}
public void changePanEffectBy(float pa, int s) {                             // -1 left, +1 right 0 center (don't work with stereo sounds)
  pan[s] += (pa * 0.01);
  pan[s] = constrain(pan[s], -1, 1);
  if (sounds[s].channels() == 1) sounds[s].pan(pan[s]);
}
public void setPanEffectTo(float pa, int s) {
  pan[s] = pa * 0.01;
  pan[s] = constrain(pan[s], -1, 1);
  if (sounds[s].channels() == 1) sounds[s].pan(pan[s]);
}
public void clearSoundEffects() {                                            // restore default sounds values
  for (int i =0; i < totalNumberOfSounds; i++) {
    pitch[i] = 1;
    volume[i] = 1;
    pan[i] = 0;
    sounds[i].amp(volume[i]);
    sounds[i].rate(pitch[i]);
    if (sounds[i].channels() == 1)sounds[i].pan(pan[i]);
  }
}
public void changeVolumeBy( float v) {                                       // work on the volume of the sound
  for (int i =0; i < totalNumberOfSounds; i++) {
    volume[i] += (v * 0.01);
    volume[i] = constrain(volume[i], 0, 1);
    sounds[i].amp(pan[i]);
  }
}
public void setVolumeTo(float v) {
  for (int i =0; i < totalNumberOfSounds; i++) {
    volume[i] = v * 0.01;
    volume[i] = constrain(volume[i], 0, 1);
    sounds[i].amp(volume[i]);
  }
}
public void changeVolumeBy( float v, int s) {                                // work on the volume of the sound
  volume[s] += (v * 0.01);
  volume[s] = constrain(volume[s], 0, 1);
  sounds[s].amp(volume[s]);
}
public void setVolumeTo(float v, int s) {
  volume[s] = v * 0.01;
  volume[s] = constrain(volume[s], 0, 1);
  sounds[s].amp(volume[s]);
}

public void pickColor() {                                                   // call it if you want to get the color of a pixel with you mouse when you click
  // (print it and display it with a text, call it in draw !!!
  if (mousePressed)println(get(mouseX, mouseY));
  push();
  textSize(16);
  fill(0, 255, 0);
  text(get(mouseX, mouseY), 20, 20);
  pop();
}

private long previousMillis = 0;
public float timer;

public void timer() {
  timer =  (millis() - previousMillis) * 0.001;
}
public void resetTimer() {
  previousMillis =  millis();
}
//================================================================ END MAIN FUNCTIONS ==========================================================================


//====================================================================== SCENE =================================================================================


public class Stage {                                                        // similare to sprite class but more light

  private PImage [] stage;
  private int backdrop = 0;
  public color colorEffectValue = -1;
  public color gostEffectValue = 255;

  public Stage( String folder) {
    try {
      String path = sketchPath()+ "/data/" + folder;
      String[] filenames = listFileNames(path);
      java.util.Arrays.sort(filenames);
      println(folder +" images : ");
      printArray(filenames);
      int totalNumberOfScenes = 0;
      int loadedScene = 0;
      for (int i = 0; i < filenames.length; i++) {
        String extention = filenames[i].substring(filenames[i].indexOf("."));
        if (extention.equals(".png") || extention.equals(".jpg") || extention.equals(".jpeg") || extention.equals(".tga") || extention.equals(".gif") ) {
          totalNumberOfScenes++;
        }
      }
      stage = new PImage [totalNumberOfScenes];
      for (int i = 0; i < filenames.length; i++) {
        String extention = filenames[i].substring(filenames[i].indexOf("."));
        if (extention.equals(".png") || extention.equals(".jpg") || extention.equals(".jpeg") || extention.equals(".tga") || extention.equals(".gif") ) {
          stage[loadedScene] = loadImage(path +"/"+ filenames[i]);
          stage[loadedScene].resize(width, height);                           // like images of sprites but with a resize function for adapting it to the screen dimentions
          loadedScene++;
        }
      }
    }
    catch(Exception e) {
      println("!!---- Caution ! There is no stageFolder at this name : " +folder+" ----!!");
      exit();
    }
    if (stage.length < 1) {
      println("!!---- Caution ! stageFolder : "+folder+ " empty ----!!");
      exit();
    }
  }

  public void backdrops() {                                                 // call it in top of draw for being behing everything
    microphone();
    timer();                                                                // for the timer
    push();
    tint(colorEffectValue, gostEffectValue);
    image(stage[backdrop], 0, 0 );
    pop();
    textToScreen();
  }

  //-------------------------------------------------------------- looks function similare to sprite --------------------------------------------------------------

  public void switchBackdropTo( int c) {
    backdrop = c;
  }
  public void nextBackdrop() {
    backdrop++;
    backdrop = backdrop%stage.length;
  }
  public void changeColorEffectBy(int col) {
    colorEffectValue -= col * 0.01 * 16777215;
  }
  public void setColorEffectTo(int col) {
    colorEffectValue = -1 + int( col * 0.01 * -16777215);
  }
  public void changeGhostEffectBy(int a) {
    gostEffectValue -= a;
    constrain(gostEffectValue, 0, 255);
  }
  public void setGhostEffectTo(int a) {
    gostEffectValue = 255 - a;
    constrain(gostEffectValue, 0, 255);
  }
  public void clearGraphicEffects() {
    gostEffectValue = 255;
    colorEffectValue = -1;
  }
}
//=================================================================== END SCENE ================================================================================

//=================================================================== PEN  ================================================================================
class Pen {
  private PGraphics pg;
  private float penX, penY, pPenX, pPenY, penSize = 1;
  private int penColor = 0, penTransparency = 255;
  private boolean penDown;                                              // Allow drawing with pen

  Pen() {
    pg = createGraphics(width, height);                                     // create a pgraphics for the pen
  }
  void attach(Sprite o) {                                       // attach the pen to the sprite coordinates and draw if down
    penX = o.x;
    penY = o.y;
    if (penDown) {
      pg.beginDraw();
      pg.push();
      pg.strokeWeight(penSize);
      pg.stroke(penColor, penTransparency);
      pg.line(penX, penY, pPenX, pPenY);
      pg.pop();
      pg.endDraw();
    }
    pPenX = o.x;
    pPenY = o.y;
    image(pg, 0, 0);
  }
  void stamp(Sprite o) {                                            // stamp the sprite at this current image
    pg.beginDraw();
    pg.translate(o.x, o.y);
    pg.push();
    rotationStyle(o);
    pg.imageMode(CENTER);
    pg.scale(o.spriteSize *0.01 * o.sens, o.spriteSize * 0.01 );                 // scale when change size and left right orientation
    pg.tint(o.colorEffectValue, o.gostEffectValue);
    pg.image(o.costumes[o.costume], 0, 0);
    pg.pop();
    pg.endDraw();
    image(pg, 0, 0);
  }

  private void rotationStyle(Sprite o) {                                           // fixe rotation to none
    if (o.rotationStyle == "left-right") {
      if (o.direction >= 0 && o.direction <=90) {
        o.sens = 1;
      } else if (o.direction >= -90 && o.direction <=0) {
        o.sens = 1;
      } else {
        o.sens = -1;
      }
    }
    if (o.rotationStyle == "don't rotate") {
      o.sens = 1;
    }
    if (o.rotationStyle == "all around") {
      pg.rotate(o.angleRadian);
      o.sens = 1;
    }
  }


  void eraseAll() {
    pg.beginDraw();
    pg.clear();
    pg.endDraw();
  }

  void penDown() {
    penDown = true;
  }
  void penUp() {
    penDown = false;
  }

  void changePenColorBy(float col) {
    penColor -= col * 0.01 * 16777215;
  }

  void setPenColorTo(float col) {
    penColor = -1 + int( col * 0.01 * -16777215);
  }
  void changePenSizeBy(float t) {
    penSize += t;
  }
  public void changePenTransparencyBy(int a) {
    penTransparency -= a;
    constrain(penTransparency, 0, 255);
  }
  public void setPenTransparencyTo(int a) {
    penTransparency = 255 - a;
    constrain(penTransparency, 0, 255);
  }
  void setPenSizeTo(float t) {
    penSize = t;
  }
}



//=================================================================== END PEN ================================================================================
