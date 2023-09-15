package R2mix.PScratch;

import java.util.ArrayList;
import processing.core.*;

public abstract class Sprite implements Runnable {

  private PApplet myParent;
  private Stage stageSprite;
  private Thread thread; // thread for each sprite
  public float x, y, direction, angleRadian, spriteWidth, spriteHeight, spriteSize = 100; // basics informations of the
                                                                                          // sprite
  public int costume, sens = 1; // actual costume and size of the sprite
  public int hitboxW, hitboxH; // change the size of the hitbox for being more precise
  public boolean showHitbox; // show the hitbox for set it up
  public int colorEffectValue = 0; // defaut color effect value (no coloration)
  public int ghostEffectValue = 255; // defaut ghost effect value (visible)
  private boolean dragable, display = true; // boolean for rotation, dragable and is displaying, (private) call it by
                                            // the named functions
  public PImage[] costumes; // costumes is an array of images
  public String rotationStyle = "all around";

  public Sprite(Stage s, String folderName) {
    // initialize the sprite
    stageSprite = s;
    thread = new Thread(this);
    myParent = stageSprite.myParent;
    x = myParent.width / 2; // default position
    y = myParent.height / 2;
    costumes = stageSprite.allAssetImages.get(folderName); // create a reference to the mainImages
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
    
    myParent.tint(255, ghostEffectValue); // color and ghost effect
    myParent.imageMode(PConstants.CENTER); // center the image like scratch does
    if (display) {
      myParent.image(costumes[costume], 0, 0); // showing the image (can be hiding and disable the color detection)
      if (colorEffectValue > 0) {
        colorEffectTint(colorEffectValue);
        myParent.image(costumes[costume], 0, 0); // showing the image (can be hiding and disable the color detection)
      }
    }

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
      int bubbleSize = 15;
      if (spriteSays.length() > 15) bubbleSize = spriteSays.length();
      if ( x <= myParent.width/2) {
        myParent.rect(0, -(spriteHeight / 2) - 48, bubbleSize * 9, 48, 48); // bubble
        myParent.triangle((spriteWidth / 2) + 16, -spriteHeight / 2, spriteWidth / 3, -spriteHeight / 4, spriteWidth / 2,
          -spriteHeight / 2); // quote
        myParent.fill(0);
        myParent.textSize(16);
        myParent.text(spriteSays, 9, -(spriteHeight / 2) - 24);
      } else {
        myParent.rect(-bubbleSize * 9, -(spriteHeight / 2) - 48, bubbleSize * 9, 48, 48); // bubble
        myParent.triangle(-(spriteWidth / 2) + 16, -spriteHeight / 2, -spriteWidth / 3, -spriteHeight / 4, -spriteWidth / 2,
          -spriteHeight / 2); // quote
        myParent.fill(0);
        myParent.textSize(16);
        myParent.text(spriteSays, -bubbleSize * 9 + 9, -(spriteHeight / 2) - 24);
      }
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
      int bubbleSize = 15;
      if (spriteThinks.length() > 15)  bubbleSize = spriteThinks.length();
      if ( x <= myParent.width/2) {
        myParent.rect(0, -(spriteHeight / 2) - 48, bubbleSize * 9, 48, 48);// bubble
        myParent.circle((spriteWidth / 2) + 16, -spriteHeight / 2, spriteWidth / 8);
        myParent.circle((spriteWidth / 3) + 16, -spriteHeight / 3, spriteWidth / 8);
        myParent.fill(0);
        myParent.textSize(16);
        myParent.text(spriteThinks, 9, -(spriteHeight / 2) - 24);
        myParent.pop();
      } else {
        myParent.rect(-bubbleSize * 9, -(spriteHeight / 2) - 48, bubbleSize * 9, 48, 48);// bubble
        myParent.circle(-(spriteWidth / 2) + 16, -spriteHeight / 2, spriteWidth / 8);
        myParent.circle(-(spriteWidth / 3) + 16, -spriteHeight / 3, spriteWidth / 8);
        myParent.fill(0);
        myParent.textSize(16);
        myParent.text(spriteThinks, -bubbleSize * 9 + 9, -(spriteHeight / 2) - 24);
        myParent.pop();
      }
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

  private void colorEffectTint(int valColor) {
    valColor = valColor%360; // limit to 360 for a circle of color
    int redValue = (int)(128 + 127 * PApplet.cos(PApplet.radians(valColor)));
    int greenValue = (int)(128 + 127 * PApplet.cos(PApplet.radians(valColor - 120)));
    int blueValue = (int)(128 + 127 * PApplet.cos(PApplet.radians(valColor - 240)));
    int currentColor = myParent.color(redValue, greenValue, blueValue); // set de current color
    myParent.tint(currentColor, PApplet.constrain(valColor * 5 * ghostEffectValue/255, 0, 360)); // apply to the image
  }

  public void changeColorEffectBy(int col) {
    colorEffectValue += col; // change color in binary to max 0 to 100
  }

  public void setColorEffectTo(int col) {
    colorEffectValue = col; // set color in binary to 0 to 100
  }

  public void changeGhostEffectBy(int a) {
    ghostEffectValue -= a;
    PApplet.constrain(ghostEffectValue, 0, 255); // prevent lower of higher value
  }

  public void setGhostEffectTo(int a) {
    ghostEffectValue = 255 - a;
    PApplet.constrain(ghostEffectValue, 0, 255);
  }

  public void clearGraphicEffects() { // restore default values
    ghostEffectValue = 255;
    colorEffectValue = 0;
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
