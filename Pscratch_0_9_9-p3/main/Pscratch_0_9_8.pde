
public abstract class Sprite implements Runnable {

  private PApplet myParent;

  public final static String VERSION = "PScratch-0.9.8";

  private Stage stageSprite;
  private Thread thread; // thread for each sprite
  public float x, y, direction, angleRadian, spriteWidth, spriteHeight, spriteSize = 100; // basics informations of the
                                                                                          // sprite
  public int costume, sens = 1; // actual costume and size of the sprite
  public int hitboxW, hitboxH; // change the size of the hitbox for being more precise
  public boolean showHitbox; // show the hitbox for set it up
  public int colorEffectValue = -1, colorCurrentValue = 0; // defaut color effect value (no coloration)
  public int gostEffectValue = 255; // defaut ghost effect value (visible)
  private boolean dragable, display = true; // boolean for rotation, dragable and is displaying, (private) call it by
                                            // the named functions
  public PImage[] costumes; // costumes is an array of images
  public String rotationStyle = "all around";

  public Sprite(Stage s) {
    // initialize the sprite
    stageSprite = s;
    thread = new Thread(this);
    myParent = stageSprite.myParent;
    x = myParent.width / 2; // default position
    y = myParent.height / 2;
  }

  public void draw() { // for override it for clones and sprites
  }

  public void start() { // start the thread
    thread.start();
  }

  public void stop() { // stop the thread
    try {
      thread.join(); // End thread safetly
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
  }

  @Override
  public void run() { // for override it for clones and sprites
  }

  // ====================================== Sprite folder research
  // =========================================================================================
  public void spriteFolder(String folderName) {
    costumes = stageSprite.allAssetImages.get(folderName); // create a reference to the mainImages
  }

  // ====================================== Show sprite and main sprite functions
  // ==================================================================

  public void display() {

    spriteWidth = (float) (costumes[costume].width * spriteSize * 0.01); // set the spriteWidth to the actual costume
                                                                         // image
    spriteHeight = (float) (costumes[costume].height * spriteSize * 0.01); // set the spriteHeight to the actual costume
                                                                           // image
    // -------------------------- start style and
    // transformations------------------------------------------------------------
    myParent.push();
    myParent.translate(x, y); // move to x and y, using translate cause rotation
    myParent.push(); // double push for prevent reverse dialog
    rotationStyle(); // rotate for orientation of the sprite
    myParent.scale((float) (spriteSize * 0.01 * sens), (float) (spriteSize * 0.01)); // scale when change size and left
                                                                                     // right orientation
    myParent.tint(colorEffectValue, gostEffectValue); // color and ghost effect
    myParent.imageMode(PConstants.CENTER); // center the image like scratch does
    if (display)
      myParent.image(costumes[costume], 0, 0); // showing the image (can be hiding and disable the color detection)
    myParent.pop();
    spriteSay(); // void for speaking of thinking are permantly checking is somthing to think/say
    spriteThink(); // need to be here in case of using say in a thread and not in draw
    myParent.pop();
    // -------------------------- end style and
    // transformations------------------------------------------------------------
    dragSprite(); // if the function dragable is called, sprite go to mouse when it's pressed
  }

  public boolean keyIsPressed(char k) { // call this boolean for interact width key

    if (stageSprite.keyStored.contains(k)) { // if array contain the letter of the keyBoard
      return true;
    } else {
      return false;
    }
  }

  public boolean keyIsPressed(String k) { // call this boolean for interact width keycoded

    if (k == "upArrow" && stageSprite.keyStoredCoded.contains(38)) { // if array contain the keycod of the keyBoard
      return true;
    } else if (k == "leftArrow" && stageSprite.keyStoredCoded.contains(37)) {
      return true;
    } else if (k == "rightArrow" && stageSprite.keyStoredCoded.contains(39)) {
      return true;
    } else if (k == "downArrow" && stageSprite.keyStoredCoded.contains(40)) {
      return true;
    } else {
      return false;
    }
  }

  // ====================================== Motion
  // =====================================================================================================================

  public void move(float a) {
    x += PApplet.cos(angleRadian) * a; // trigonometric calcul for go to the angle of the direction of the sprite
    y += PApplet.sin(angleRadian) * a;
  }

  public void moveRight(float a) {
    x += PApplet.cos(angleRadian + PConstants.PI / 2) * a; // trigonometric calcul for go to the angle of the direction
                                                           // of the sprite
    y += PApplet.sin(angleRadian + PConstants.PI / 2) * a;
  }

  public void moveLeft(float a) {
    x += PApplet.cos(angleRadian + PConstants.PI / 2) * -a; // trigonometric calcul for go to the angle of the direction
                                                            // of the sprite
    y += PApplet.sin(angleRadian + PConstants.PI / 2) * -a;
  }

  public void turnRight(float a) {
    direction += a;
    direction = direction % 360; // rotation with reset on 360 degree then converted in radian
    angleRadian = PApplet.radians(direction);
  }

  public void turnLeft(float a) {
    direction -= a;
    direction = direction % -360;
    angleRadian = PApplet.radians(direction);
  }

  public void goTo(String s) {
    if (s == "mouse") {
      x = myParent.mouseX;
      y = myParent.mouseY;
    }
    if (s == "randomPosition") {
      x = myParent.random(myParent.width);
      y = myParent.random(myParent.height);
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
    angleRadian = PApplet.radians(direction);
  }

  public void pointTowards(float xx, float yy) {
    angleRadian = PApplet.atan2(yy - y, xx - x); // transform a matrix of position to an angle (in radians)
    direction = PApplet.degrees(angleRadian);
  }

  public void pointTowards(String mouseIn) {
    if (mouseIn == "mouse")
      angleRadian = PApplet.atan2(myParent.mouseY - y, myParent.mouseX - x);
    direction = PApplet.degrees(angleRadian);
  }

  public void pointTowards(Sprite o) {
    angleRadian = PApplet.atan2(o.y - y, o.x - x);
    direction = PApplet.degrees(angleRadian);
  }

  // ---------------------------------------glide system, better call it in run
  // void ---------------------------------------------------
  private float startX, startY; // start position
  private boolean isGliding; // statement

  public void glide(float time, float xx, float yy) { // time in sec of gliding and end positions
    if (!isGliding) { // init before gliding
      startX = x;
      startY = y;
      isGliding = true;
    }
    int frac = (int) (time * 1000) / 16; // time calculation

    for (int i = 0; i < frac; i++) { // move for each 16 millisecond to the end position
      x += (xx - startX) / (frac);
      y += (yy - startY) / (frac);
      myParent.delay(16);
    }
    isGliding = false; // end of gliding
    x = xx; // repositionate in case of float number.
    y = yy;
  }
  // ------------------------------------------------- END glide system---
  // ---------------------------------------------------------

  public void glide(float t, String txt) { // glide ton mouse or random, also better call it in run void
    if (txt == "randomPosition") {
      glide(t, myParent.random(myParent.width), myParent.random(myParent.height));
    }
    if (txt == "mouse") {
      glide(t, myParent.mouseX, myParent.mouseY);
    }
  }

  public void glide(float t, Sprite o) { // glide to sprite, also better call it in run void
    glide(t, o.x, o.y);
  }

  public void changeXBy(float add) {
    x += add;
  }

  public void setXTo(float a) {
    x = a;
  }

  public void changeYBy(float add) {
    y += add;
  }

  public void setYTo(float a) {
    y = a;
  }

  public void ifOnEdgeBounce() { // bounce on edge of the screen
    if (x + spriteWidth / 2 > myParent.width) {
      pointInDirection(180 - direction);
      setXTo(myParent.width - spriteWidth / 2);
    }
    if (x - spriteWidth / 2 < 0) {
      pointInDirection(180 - direction);
      setXTo(spriteWidth / 2);
    }
    if (y + spriteHeight / 2 > myParent.height) {
      pointInDirection(direction * -1);
      setYTo(myParent.height - spriteHeight / 2);
    }
    if (y - spriteHeight / 2 < 0) {
      pointInDirection(direction * -1);
      setYTo(spriteHeight / 2);
    }
    direction = direction % -360;
  }

  public void setRotationStyle(String rs) { // fixe rotation to none
    rotationStyle = rs;
  }

  private void rotationStyle() { // fixe rotation to none
    if (rotationStyle == "left-right") {
      if (direction >= 0 && direction <= 90) {
        sens = 1;
      } else if (direction >= -90 && direction <= 0) {
        sens = 1;
      } else {
        sens = -1;
      }
    }
    if (rotationStyle == "don't rotate") {
      sens = 1;
    }
    if (rotationStyle == "all around") {
      myParent.rotate(angleRadian);
      sens = 1;
    }
  }

  // ====================================== Looks
  // =====================================================================================================================

  private String spriteSays, spriteThinks; // sprite always have a things to say of thing, they are speaky

  public void spriteSay() {
    if (spriteSays != null && spriteSays.length() > 0 && display) { // only display if something is written
      myParent.push();
      myParent.fill(255);
      myParent.noStroke();
      int bubbleSize = 12;
      if (spriteSays.length() > 12)
        bubbleSize = spriteSays.length();
      myParent.rect(0, -(spriteHeight / 2) - 48, bubbleSize * 11, 48, 48); // bubble
      myParent.triangle((spriteWidth / 2) + 16, -spriteHeight / 2, spriteWidth / 3, -spriteHeight / 4, spriteWidth / 2,
          -spriteHeight / 2); // quote
      myParent.fill(0);
      myParent.textSize(16);
      myParent.text(spriteSays, 20, -(spriteHeight / 2) - 24);
      myParent.pop();
    }
  }

  public void say(String txt) {
    spriteSays = txt;
  }

  public void say(String txt, float time) { // only use in a thread !!! or block the entire project
    say(txt);
    myParent.delay((int) time * 1000); // add time then converted into miliseconds
    spriteSays = null; // set to null for hidding dialog
  }

  public void spriteThink() { // as say but for thinking
    if (spriteThinks != null && spriteThinks.length() > 0 && display) {
      myParent.push();
      myParent.fill(255);
      myParent.noStroke();
      int bubbleSize = 12;
      if (spriteThinks.length() > 12)
        bubbleSize = spriteThinks.length();
      myParent.rect(0, -(spriteHeight / 2) - 48, bubbleSize * 11, 48, 48);// bubble
      myParent.circle((spriteWidth / 2) + 16, -spriteHeight / 2, spriteWidth / 8);
      myParent.circle((spriteWidth / 3) + 16, -spriteHeight / 3, spriteWidth / 8);
      myParent.fill(0);
      myParent.textSize(16);
      myParent.text(spriteThinks, 20, -(spriteHeight / 2) - 24);
      myParent.pop();
    }
  }

  public void think(String txt) {
    spriteThinks = txt;
  }

  public void think(String txt, float time) {
    think(txt);
    myParent.delay((int) time * 1000);
    spriteThinks = null;
  }

  public void switchCostumeTo(int c) {
    costume = PApplet.abs(c);
    costume = costume % costumes.length; // loop costume to 0 is longer than max costume
  }

  public void nextCostume() {
    costume++;
    costume = costume % costumes.length; // loop costume to 0 is longer than max costume
  }

  public void changeSizeBy(float t) { // for all costumes
    spriteSize += t;
    if (spriteSize < 1)
      spriteSize = 1; // prevent 0
  }

  public void setSizeTo(float t) {
    spriteSize = t;
    if (spriteSize < 1)
      spriteSize = 1;
  }

  public void changeColorEffectBy(int col) {
    colorCurrentValue += col; // change color in binary to max 0 to 100
    colorEffectValue = (int) PApplet.map(colorCurrentValue % 255, 0, 255, -1, -16777216 / 100);
  }

  public void setColorEffectTo(int col) {
    colorEffectValue = (int) PApplet.map(col % 255, 0, 255, -1, -16777216 / 100); // set color in binary to 0 to 100
  }

  public void changeGhostEffectBy(int a) {
    gostEffectValue -= a;
    PApplet.constrain(gostEffectValue, 0, 255); // prevent lower of higher value
  }

  public void setGhostEffectTo(int a) {
    gostEffectValue = 255 - a;
    PApplet.constrain(gostEffectValue, 0, 255);
  }

  public void clearGraphicEffects() { // restore default values
    gostEffectValue = 255;
    colorEffectValue = -1;
  }

  public void show() { // displaying the sprite
    display = true;
  }

  public void hide() { // hidding the sprite
    display = false;
  }

  // ====================================== sensor
  // =====================================================================================================

  // ------------------------------------------------------------- detect colors
  // behind the sprite
  // ------------------------------------------------------------------

  public boolean touch(int col) { // call this boolean for testing if touching color
    int l = (int) (spriteWidth);
    int h = (int) (spriteHeight);
    boolean colorTouched = false;
    for (int i = 0; i < l; i++) {
      for (int j = 0; j < h; j++) { // for only if the sprite has a color at this point
        if (myParent.get((int) (x + i - l / 2), (int) (y + j - h / 2)) == col && display) {
          colorTouched = true;
        }
      }
    }
    if (colorTouched) { // if the color is present into the list of colors stored
      return true;
    } else {
      return false;
    }
  }

  public boolean touch(float xx, float yy, float l, float h, float di) { // square hitbox comparing two position and
                                                                         // size
    float hL = spriteWidth / 2 + hitboxW; // for changing the hitbox size
    float hH = spriteHeight / 2 + hitboxH;

    float cx1 = x + hL * PApplet.cos(PApplet.radians(direction)) - hH * PApplet.sin(PApplet.radians(direction));
    float cy1 = y + hL * PApplet.sin(PApplet.radians(direction)) + hH * PApplet.cos(PApplet.radians(direction));
    float cx2 = x - hL * PApplet.cos(PApplet.radians(direction)) - hH * PApplet.sin(PApplet.radians(direction));
    float cy2 = y - hL * PApplet.sin(PApplet.radians(direction)) + hH * PApplet.cos(PApplet.radians(direction));
    float cx3 = x - hL * PApplet.cos(PApplet.radians(direction)) + hH * PApplet.sin(PApplet.radians(direction));
    float cy3 = y - hL * PApplet.sin(PApplet.radians(direction)) - hH * PApplet.cos(PApplet.radians(direction));
    float cx4 = x + hL * PApplet.cos(PApplet.radians(direction)) + hH * PApplet.sin(PApplet.radians(direction));
    float cy4 = y + hL * PApplet.sin(PApplet.radians(direction)) - hH * PApplet.cos(PApplet.radians(direction));
    float[] spriteXx = { cx1, cx2, cx3, cx4 };
    float[] spriteYy = { cy1, cy2, cy3, cy4 };

    float cxother1 = xx + l / 2 * PApplet.cos(PApplet.radians(di)) - h / 2 * PApplet.sin(PApplet.radians(di));
    float cyother1 = yy + l / 2 * PApplet.sin(PApplet.radians(di)) + h / 2 * PApplet.cos(PApplet.radians(di));
    float cxother2 = xx - l / 2 * PApplet.cos(PApplet.radians(di)) - h / 2 * PApplet.sin(PApplet.radians(di));
    float cyother2 = yy - l / 2 * PApplet.sin(PApplet.radians(di)) + h / 2 * PApplet.cos(PApplet.radians(di));
    float cxother3 = xx - l / 2 * PApplet.cos(PApplet.radians(di)) + h / 2 * PApplet.sin(PApplet.radians(di));
    float cyother3 = yy - l / 2 * PApplet.sin(PApplet.radians(di)) - h / 2 * PApplet.cos(PApplet.radians(di));
    float cxother4 = xx + l / 2 * PApplet.cos(PApplet.radians(di)) + h / 2 * PApplet.sin(PApplet.radians(di));
    float cyother4 = yy + l / 2 * PApplet.sin(PApplet.radians(di)) - h / 2 * PApplet.cos(PApplet.radians(di));
    float[] otherXx = { cxother1, cxother2, cxother3, cxother4 };
    float[] otherYy = { cyother1, cyother2, cyother3, cyother4 };

    boolean returnTouch = false;

    if (showHitbox) {
      myParent.push();
      myParent.strokeWeight(10);
      myParent.point(cx1, cy1);
      myParent.point(cx2, cy2);
      myParent.point(cx3, cy3);
      myParent.point(cx4, cy4);
      myParent.pop();

      myParent.push();
      myParent.strokeWeight(10);
      myParent.point(cxother1, cyother1);
      myParent.point(cxother2, cyother2);
      myParent.point(cxother3, cyother3);
      myParent.point(cxother4, cyother4);
      myParent.pop();
    }
    for (int i = 0; i < 4; i++) {
      float mx = spriteXx[i] - xx;
      float my = spriteYy[i] - yy;
      float mxRot = mx * PApplet.cos(-PApplet.radians(di)) - my * PApplet.sin(-PApplet.radians(di));
      float myRot = mx * PApplet.sin(-PApplet.radians(di)) + my * PApplet.cos(-PApplet.radians(di));
      float mx2 = otherXx[i] - x;
      float my2 = otherYy[i] - y;
      float mxRot2 = mx2 * PApplet.cos(-PApplet.radians(direction))
          - my2 * PApplet.sin(-PApplet.radians(direction));
      float myRot2 = mx2 * PApplet.sin(-PApplet.radians(direction))
          + my2 * PApplet.cos(-PApplet.radians(direction));

      if ((mxRot >= -l / 2 && mxRot <= l / 2 && myRot >= -h / 2 && myRot <= h / 2)
          || (mxRot2 >= -hL && mxRot2 <= hL && myRot2 >= -hH && myRot2 <= hH)) {
        returnTouch = true;
      }
    }
    if (returnTouch && display) {
      return true;
    } else {
      return false;
    }
  }

  public boolean touch(float xx, float yy, float l, float h) { // square hitbox comparing two position and size
    if (touch(xx, yy, l, h, 0) && display) {
      return true;
    } else {
      return false;
    }
  }

  public boolean touch(Sprite other) {
    if (touch(other.x, other.y, other.spriteWidth, other.spriteHeight, other.direction) && other.display && display) {
      return true;
    } else {
      return false;
    }
  }

  public boolean touch(String s) { // square hitbox comparing to :
    float hL = spriteWidth / 2 + hitboxW;
    float hH = spriteHeight / 2 + hitboxH;
    if (display) {
      // touch edge
      if (s == "edge" && (x + hL > myParent.width ||
          x - hL < 0 ||
          y + hH > myParent.height ||
          y - hH < 0)) {
        return true;
      }
      // touch mouse
      else if (s == "mouse" && touch(myParent.mouseX, myParent.mouseY, 0, 0)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  public float distanceTo(String s) { // get the distance to mouse or a sprite, position
    if (s == "mouse") {
      return PApplet.dist(x, y, myParent.mouseX, myParent.mouseY);
    } else {
      return 0; // if string is not mouse, prevent null
    }
  }

  public float distanceTo(Sprite o) {
    return PApplet.dist(x, y, o.x, o.y);
  }

  public float distanceTo(float xx, float yy) {
    return PApplet.dist(x, y, xx, yy);
  }

  public void setDragMode(boolean drag) { // call it for enable or disable if the sprite is dragable, dont use the
                                          // boolean only this void
    dragable = drag;
  }

  private void dragSprite() { // don't call it is automatique if you enable with the setDrageMode void
    if (dragable && myParent.mousePressed && touch("mouse")) {
      x = myParent.mouseX;
      y = myParent.mouseY;
    }
  }

  // -----------ASK
  // BLOCK------------------------------------------------------------------
  public void ask(String s) { // ask block is a stage function but each sprite call it by this function.
    stageSprite.answer = "";
    if (!stageSprite.isAsking) {
      stageSprite.isAsking = true;
      say(s); // display the question
    }
  }

  public void askAndWait(String s) {                                                       // ask block is a stage function but each sprite call it by this function.
    stageSprite.answer = "";
    if (!stageSprite.isAsking) {
        stageSprite.isAsking = true;
        say(s);          // display the question
    }
      while (stageSprite.answer.length() < 1) {
        myParent.delay(16);
      }
      say("");
    }

  
  // --------------------------------------------------------------------------------------------

  // -----------For clones
  // return------------------------------------------------------------------

  // -----------Touch------------------------------------------------------------------
  public boolean touch(ArrayList<? extends Sprite> listA, Sprite sprite) {
    for (int i = listA.size() - 1; i >= 0; i--) { // call la méthode "draw" de l'interface
      if (listA.get(i).touch(sprite)) {
        return true; // The clone from listA touches the sprite
      }
    }
    return false; // No collision detected
  }
  // -----------------------------------------------------------------------------------
}

// ========================================================================= END
// OF SPRITE CLASS
// ================================================================

//====================================================================== SCENE =================================================================================

public class Stage {
  public PApplet myParent;

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
    if (myParent.mousePressed)PApplet.println(myParent.get(myParent.mouseX, myParent.mouseY), "mouseX : "+ myParent.mouseX, "mouseY : " + myParent.mouseY, "width : " + myParent.width, "height : " + myParent.height, "frameRate : " + (int)(myParent.frameRate ));
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
        String extention = filenames[i].substring(filenames[i].indexOf(".")); // separate extention for separate img to
                                                                              // sounds and prevent otherfiles
        if (extention.equals(".png") || extention.equals(".jpg") || extention.equals(".jpeg")
            || extention.equals(".tga") || extention.equals(".gif")) {
          totalNumberOfCostumes++; // var for knowing the number of images
        }
      }
      costumes = new PImage[totalNumberOfCostumes]; // init the array of images width the checked up
                                                    // totalNumberOfCostumes var
      for (int i = 0; i < filenames.length; i++) { // iterate for importing them
        String extention = filenames[i].substring(filenames[i].indexOf(".")); // check extention prevent fail
        if (extention.equals(".png") || extention.equals(".jpg") || extention.equals(".jpeg")
            || extention.equals(".tga") || extention.equals(".gif")) {
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
  private int backdrop = 0;
  public int colorEffectValue = -1;
  public int gostEffectValue = 255;

  public Stage(PApplet theParent, String folder) {
    myParent = theParent;
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

  public void backdrops() { // call it in top of draw for being behing everything
    timer(); // for the timer
    myParent.push();
    myParent.tint(colorEffectValue, gostEffectValue);
    myParent.image(stage[backdrop], 0, 0, myParent.width, myParent.height);
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

  public void changeColorEffectBy(int col) {
    colorEffectValue -= col * 0.01 * 16777215;
  }

  public void setColorEffectTo(int col) {
    colorEffectValue = -1 + (int)( col * 0.01 * -16777215);
  }

  public void changeGhostEffectBy(int a) {
    gostEffectValue -= a;
    PApplet.constrain(gostEffectValue, 0, 255);
  }

  public void setGhostEffectTo(int a) {
    gostEffectValue = 255 - a;
    PApplet.constrain(gostEffectValue, 0, 255);
  }

  public void clearGraphicEffects() {
    gostEffectValue = 255;
    colorEffectValue = -1;
  }
}
// =================================================================== END SCENE
// ================================================================================

//sound lib
import processing.sound.*;


public class Sounds {

    // --------------------------------------------------------import sounds
    // ---------------------------------------------------------------------
    private SoundFile[] sounds; // array of sounds look in sprite and work the same but with sounds
    private int totalNumberOfSounds, loadedSound;
    private AudioIn input;
    private Amplitude amplitude;
    public int loudness;
    public boolean openMic;
    // private float pitch = 1, volume = 1, pan = 0; //defaut sounds values
    private float[] pitch, volume, pan;

    private Stage stageSprite;
    private PApplet myParent;

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


    public Sounds(Stage s, String folder) {
        stageSprite = s;
        myParent = stageSprite.myParent;
    
        try {
            String path = myParent.sketchPath() + "/data/" + folder;
            String[] filenames = listFileNames(path);
            java.util.Arrays.sort(filenames);
            PApplet.println(folder + " sounds : ");
            PApplet.printArray(filenames);
            for (int i = 0; i < filenames.length; i++) {
                String extention = filenames[i].substring(filenames[i].indexOf("."));
                if (extention.equals(".wav") || extention.equals(".mp3") || extention.equals(".aiff")) {
                    totalNumberOfSounds++;
                }
            }
            sounds = new SoundFile[totalNumberOfSounds];
            pitch = new float[totalNumberOfSounds];
            volume = new float[totalNumberOfSounds];
            pan = new float[totalNumberOfSounds];

            for (int i = 0; i < filenames.length; i++) {
                String extention = filenames[i].substring(filenames[i].indexOf("."));
                if (extention.equals(".wav") || extention.equals(".mp3") || extention.equals(".aiff")) {
                    sounds[loadedSound] = new SoundFile(stageSprite.myParent, path + "/" + filenames[i], false);
                    loadedSound++;
                }
            }
        } catch (Exception e) {
            PApplet.println("!!---- Caution ! There is no SoundFolder at this name : " + folder + " ----!!");
        }
        openMicrophone();
        clearSoundEffects();
    }
    // -----------------------------------------------------END import sounds
    // ---------------------------------------------------------------------

    void openMicrophone() { // call it inside setup void
        try {
            input = new AudioIn(stageSprite.myParent, 0); // new default mic
            input.start(); // start mic
            amplitude = new Amplitude(stageSprite.myParent); // new analyser
            amplitude.input(input); // attach input to analyzer
            openMic = true;
        } catch (Exception e) {
            openMic = false;
            PApplet.println("---!! no microphone detected  !!---");
        }
    }

void microphone() {                                                            // call it inside draw void
  if (openMic) {
    loudness = (int)(amplitude.analyze() * 100);                                  // analyze the sound and convert to 100
  }
}

    // --------------------------------------------------------------------------------------------

    public void playSound(int numeroSon) { // play a sound from 0 with pitch[i] value and volume value
        sounds[numeroSon].play(pitch[numeroSon], volume[numeroSon]);
        if (sounds[numeroSon].channels() == 1)
            sounds[numeroSon].pan(pan[numeroSon]);
    }

    public void playSoundUntilDown(int numeroSon) { // wait the sound is over before go to the next code ling, better
                                                    // using is into run void
        playSound(numeroSon);
        while (sounds[numeroSon].isPlaying() && sounds[numeroSon].percent() < 100)
            ;
        sounds[numeroSon].stop();
    }

    public void stopSound(int numeroSon) { // stop a sound
        sounds[numeroSon].stop();
    }

    public void stopAllSound() { // stop all sounds
        for (int i = 0; i < totalNumberOfSounds; i++) {
            sounds[i].stop();
        }
    }

    public void changePitchEffectBy(float p) { // change pitch[i] of a sound by changing it rate (like on scratch)
        for (int i = 0; i < totalNumberOfSounds; i++) {
            pitch[i] += p * 0.01;
            pitch[i] = PApplet.constrain(pitch[i], 0, 100);
            sounds[i].rate(pitch[i]);
        }
    }

    public void setPitchEffectTo(float p) {
        for (int i = 0; i < totalNumberOfSounds; i++) {
            pitch[i] = (float) (p * 0.01);
            pitch[i] = PApplet.constrain(pitch[i], 0, 100);
            sounds[i].rate(pitch[i]);
        }
    }

    public void changePanEffectBy(float pa) { // -1 left, +1 right 0 center (don't work with stereo sounds)
        for (int i = 0; i < totalNumberOfSounds; i++) {
            pan[i] += (pa * 0.01);
            pan[i] = PApplet.constrain(pan[i], -1, 1);
            if (sounds[i].channels() == 1)
                sounds[i].pan(pan[i]);
        }
    }

    public void setPanEffectTo(float pa) {
        for (int i = 0; i < totalNumberOfSounds; i++) {
            pan[i] = (float) (pa * 0.01);
            pan[i] = PApplet.constrain(pan[i], -1, 1);
            if (sounds[i].channels() == 1)
                sounds[i].pan(pan[i]);
        }
    }

    public void changePitchEffectBy(float p, int s) { // change pitch[i] of a sound by changing it rate (like on
                                                      // scratch)
        pitch[s] += p * 0.01;
        pitch[s] = PApplet.constrain(pitch[s], 0, 100);
        sounds[s].rate(pitch[s]);
    }

    public void setPitchEffectTo(float p, int s) {
        pitch[s] = (float) (p * 0.01);
        pitch[s] = PApplet.constrain(pitch[s], 0, 100);
        sounds[s].rate(pitch[s]);
    }

    public void changePanEffectBy(float pa, int s) { // -1 left, +1 right 0 center (don't work with stereo sounds)
        pan[s] += (pa * 0.01);
        pan[s] = PApplet.constrain(pan[s], -1, 1);
        if (sounds[s].channels() == 1)
            sounds[s].pan(pan[s]);
    }

    public void setPanEffectTo(float pa, int s) {
        pan[s] = (float) (pa * 0.01);
        pan[s] = PApplet.constrain(pan[s], -1, 1);
        if (sounds[s].channels() == 1)
            sounds[s].pan(pan[s]);
    }

    public void clearSoundEffects() { // restore default sounds values
        for (int i = 0; i < totalNumberOfSounds; i++) {
            pitch[i] = 1;
            volume[i] = 1;
            pan[i] = 0;
            sounds[i].amp(volume[i]);
            sounds[i].rate(pitch[i]);
            if (sounds[i].channels() == 1)
                sounds[i].pan(pan[i]);
        }
    }

    public void changeVolumeBy(float v) { // work on the volume of the sound
        for (int i = 0; i < totalNumberOfSounds; i++) {
            volume[i] += v * 0.01;
            volume[i] = PApplet.constrain(volume[i], 0, 1);
            sounds[i].amp(pan[i]);
        }
    }

    public void setVolumeTo(float v) {
        for (int i = 0; i < totalNumberOfSounds; i++) {
            volume[i] = (float) (v * 0.01);
            volume[i] = PApplet.constrain(volume[i], 0, 1);
            sounds[i].amp(volume[i]);
        }
    }

    public void changeVolumeBy(float v, int s) { // work on the volume of the sound
        volume[s] += (v * 0.01);
        volume[s] = PApplet.constrain(volume[s], 0, 1);
        sounds[s].amp(volume[s]);
    }

    public void setVolumeTo(float v, int s) {
        volume[s] = (float) (v * 0.01);
        volume[s] = PApplet.constrain(volume[s], 0, 1);
        sounds[s].amp(volume[s]);
    }
    // ----------------------------------------------------------------END OF SOUNDS
    // ---------------------------------------------------------------------------

}


public class Pen {

    private Stage stageSprite;
    private PApplet myParent;
    // =================================================================== PEN
    // ================================================================================
    private PGraphics pg;
    private float penX, penY, pPenX, pPenY, penSize = 1;
    private int penColor = 0, penTransparency = 255;
    private boolean penDown; // Allow drawing with pen

    public Pen(Stage s) {
        stageSprite = s;
        myParent = stageSprite.myParent;
        pg = myParent.createGraphics(myParent.width, myParent.height); // create a pgraphics for the pen
    }

    public void attach(Sprite o) { // attach the pen to the sprite coordinates and draw if down
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
        myParent.image(pg, 0, 0);
    }

    public void stamp(Sprite o) { // stamp the sprite at this current image
        pg.beginDraw();
        pg.translate(o.x, o.y);
        pg.push();
        rotationStyle(o);
        pg.imageMode(PApplet.CENTER);
        pg.scale((float) (o.spriteSize * 0.01 * o.sens), (float) (o.spriteSize * 0.01)); // scale when change size and
                                                                                         // left right orientation
        pg.tint(o.colorEffectValue, o.gostEffectValue);
        pg.image(o.costumes[o.costume], 0, 0);
        pg.pop();
        pg.endDraw();
        myParent.image(pg, 0, 0);
    }

    private void rotationStyle(Sprite o) { // fixe rotation to none
        if (o.rotationStyle == "left-right") {
            if (o.direction >= 0 && o.direction <= 90) {
                o.sens = 1;
            } else if (o.direction >= -90 && o.direction <= 0) {
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

    public void eraseAll() {
        pg.beginDraw();
        pg.clear();
        pg.endDraw();
    }

    public void penDown() {
        penDown = true;
    }

    public void penUp() {
        penDown = false;
    }

    public void changePenColorBy(float col) {
        penColor -= col * 0.01 * 16777215;
    }

    public void setPenColorTo(float col) {
        penColor = (int) (-1 + col * 0.01 * -16777215);
    }

    public void changePenSizeBy(float t) {
        penSize += t;
    }

    public void changePenTransparencyBy(int a) {
        penTransparency -= a;
        PApplet.constrain(penTransparency, 0, 255);
    }

    public void setPenTransparencyTo(int a) {
        penTransparency = 255 - a;
        PApplet.constrain(penTransparency, 0, 255);
    }

    public void setPenSizeTo(float t) {
        penSize = t;
    }
}

// =================================================================== END PEN
// ================================================================================
