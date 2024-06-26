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
  public float hitboxW, hitboxH; // change the size of the hitbox for being more precise
  public float offsetX, offsetY; // offset of the displayed image independently of the hitbox
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
      myParent.image(costumes[costume], offsetX, offsetY); // showing the image (can be hiding and disable the color
                                                           // detection)
      if (colorEffectValue > 0) {
        colorEffectTint(colorEffectValue);
        myParent.image(costumes[costume], offsetX, offsetY); // showing the image (can be hiding and disable the color
                                                             // detection)
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

  // ??????? version with pg for insertion into a PGraphic, for now entended for
  // beta, futur poly or overr
  public void display(PGraphics pg) {
    pg.beginDraw();
    spriteWidth = (float) (costumes[costume].width * spriteSize * 0.01); // set the spriteWidth to the actual costume
                                                                         // image
    spriteHeight = (float) (costumes[costume].height * spriteSize * 0.01); // set the spriteHeight to the actual costume
                                                                           // image
    // -------------------------- start style and
    // transformations------------------------------------------------------------
    pg.push();
    pg.translate(x, y); // move to x and y, using translate cause rotation
    pg.push(); // double push for prevent reverse dialog
    rotationStyle(pg); // rotate for orientation of the sprite
    pg.scale((float) (spriteSize * 0.01 * sens), (float) (spriteSize * 0.01)); // scale when change size and left
    pg.tint(255, ghostEffectValue); // color and ghost effect
    pg.imageMode(PConstants.CENTER); // center the image like scratch does
    if (display) {
      pg.image(costumes[costume], offsetX, offsetY); // showing the image (can be hiding and disable the color
                                                     // detection)
      if (colorEffectValue > 0) {
        colorEffectTint(colorEffectValue, pg);
        pg.image(costumes[costume], offsetX, offsetY); // showing the image (can be hiding and disable the color
                                                       // detection)
      }
    }

    pg.pop();
    spriteSay(pg); // void for speaking of thinking are permantly checking is somthing to think/say
    spriteThink(pg); // need to be here in case of using say in a thread and not in draw
    pg.pop();
    // -------------------------- end style and
    // transformations------------------------------------------------------------
    dragSprite(); // if the function dragable is called, sprite go to mouse when it's pressed
    pg.endDraw();
  }

  // deleting the clone is the boolean become true, avoid bad remove from array
  // and crash
  public boolean deleteThisClone = false;

  // call this fuction instead changing the boolean, more accurate to scratch but
  // both works
  public void deleteThisClone() {
    deleteThisClone = true;
  }

  public boolean keyIsPressed(char k) { // call this boolean for interact width key
    return stageSprite.keyIsPressed(k);
  }

  public boolean keyIsPressed(String k) { // call this boolean for interact width keycoded
    return stageSprite.keyIsPressed(k);
  }

  public void modifyOffsetX(int offset) {
    offsetX = offset;
  }

  public void modifyOffsetY(int offset) {
    offsetY = offset;
  }

  // animate with frameCount, call it into draw
  public void animate(int startAnimation, int endAnimation, int frameAnimation){
    if (myParent.frameCount % frameAnimation == 0) {
      nextCostume();
      switchCostumeTo(costume%endAnimation);
      if (costume < startAnimation) switchCostumeTo(startAnimation);
    }
  }

  // animate with time in MS and breakcondition, call it into run
  public void animate(int startAnimation, int endAnimation, int time, boolean breakPoint){
    switchCostumeTo(startAnimation);
    for(int i = startAnimation; i < endAnimation; i++){
      if(breakPoint){
        break;
      }
      myParent.delay(time);
      nextCostume();
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

  // version with pg for insertion into a PGraphic
  private void rotationStyle(PGraphics pg) { // fixe rotation to none
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
      pg.rotate(angleRadian);
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
      myParent.textSize(16);
      float bubbleSize = 200;
      if (myParent.textWidth(spriteSays) > 200)
        bubbleSize = myParent.textWidth(spriteSays);

      if (x <= myParent.width / 2) {
        myParent.rect(0, -(spriteHeight / 2) - 48, bubbleSize + 16, 48, 48); // bubble
        myParent.triangle((spriteWidth / 2) + 16, -spriteHeight / 2, spriteWidth / 3, -spriteHeight / 4,
            spriteWidth / 2,
            -spriteHeight / 2); // quote
        myParent.fill(0);
        myParent.text(spriteSays, 9, -(spriteHeight / 2) - 24);
      } else {
        myParent.rect(-bubbleSize, -(spriteHeight / 2) - 48, bubbleSize + 16, 48, 48); // bubble
        myParent.triangle(-(spriteWidth / 2) + 16, -spriteHeight / 2, -spriteWidth / 3, -spriteHeight / 4,
            -spriteWidth / 2,
            -spriteHeight / 2); // quote
        myParent.fill(0);
        myParent.text(spriteSays, -bubbleSize + 9, -(spriteHeight / 2) - 24);
      }
      myParent.pop();
    }
  }

  // version with pg for insertion into a PGraphic
  public void spriteSay(PGraphics pg) {
    if (spriteSays != null && spriteSays.length() > 0 && display) { // only display if something is written
      pg.push();
      pg.fill(255);
      pg.noStroke();
      pg.textSize(16);
      float bubbleSize = 200;
      if (myParent.textWidth(spriteSays) > 200)
        bubbleSize = myParent.textWidth(spriteSays);

      if (x <= pg.width / 2) {
        pg.rect(0, -(spriteHeight / 2) - 48, bubbleSize + 16, 48, 48); // bubble
        pg.triangle((spriteWidth / 2) + 16, -spriteHeight / 2, spriteWidth / 3, -spriteHeight / 4, spriteWidth / 2,
            -spriteHeight / 2); // quote
        pg.fill(0);
        pg.text(spriteSays, 9, -(spriteHeight / 2) - 24);
      } else {
        pg.rect(-bubbleSize * 9, -(spriteHeight / 2) - 48, bubbleSize + 16, 48, 48); // bubble
        pg.triangle(-(spriteWidth / 2) + 16, -spriteHeight / 2, -spriteWidth / 3, -spriteHeight / 4, -spriteWidth / 2,
            -spriteHeight / 2); // quote
        pg.fill(0);
        pg.text(spriteSays, -bubbleSize + 9, -(spriteHeight / 2) - 24);
      }
      pg.pop();
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
      myParent.textSize(16);
      float bubbleSize = 200;
      if (myParent.textWidth(spriteThinks) > 200)
        bubbleSize = myParent.textWidth(spriteThinks);

      if (x <= myParent.width / 2) {
        myParent.rect(0, -(spriteHeight / 2) - 48, bubbleSize + 16, 48, 48); // bubble
        myParent.circle((spriteWidth / 2) + 16, -spriteHeight / 2, spriteWidth / 8);
        myParent.circle((spriteWidth / 3) + 16, -spriteHeight / 3, spriteWidth / 8);
        myParent.fill(0);
        myParent.text(spriteThinks, 9, -(spriteHeight / 2) - 24);
        myParent.pop();
      } else {
        myParent.rect(-bubbleSize, -(spriteHeight / 2) - 48, bubbleSize + 16, 48, 48); // bubble
        myParent.circle(-(spriteWidth / 2) + 16, -spriteHeight / 2, spriteWidth / 8);
        myParent.circle(-(spriteWidth / 3) + 16, -spriteHeight / 3, spriteWidth / 8);
        myParent.fill(0);
        myParent.text(spriteThinks, -bubbleSize + 9, -(spriteHeight / 2) - 24);
        myParent.pop();
      }
    }
  }

  // version with pg for insertion into a PGraphic
  public void spriteThink(PGraphics pg) { // as say but for thinking
    if (spriteThinks != null && spriteThinks.length() > 0 && display) {
      pg.push();
      pg.fill(255);
      pg.noStroke();
      pg.textSize(16);
      float bubbleSize = 200;
      if (myParent.textWidth(spriteThinks) > 200)
        bubbleSize = myParent.textWidth(spriteThinks);

      if (x <= pg.width / 2) {
        pg.rect(0, -(spriteHeight / 2) - 48, bubbleSize + 16, 48, 48); // bubble
        pg.circle((spriteWidth / 2) + 16, -spriteHeight / 2, spriteWidth / 8);
        pg.circle((spriteWidth / 3) + 16, -spriteHeight / 3, spriteWidth / 8);
        pg.fill(0);
        pg.text(spriteThinks, 9, -(spriteHeight / 2) - 24);
        pg.pop();
      } else {
        pg.rect(-bubbleSize, -(spriteHeight / 2) - 48, bubbleSize + 16, 48, 48); // bubble
        pg.circle(-(spriteWidth / 2) + 16, -spriteHeight / 2, spriteWidth / 8);
        pg.circle(-(spriteWidth / 3) + 16, -spriteHeight / 3, spriteWidth / 8);
        pg.fill(0);
        pg.text(spriteThinks, -bubbleSize + 9, -(spriteHeight / 2) - 24);
        pg.pop();
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
    valColor = valColor % 360; // limit to 360 for a circle of color
    int redValue = (int) (128 + 127 * PApplet.cos(PApplet.radians(valColor)));
    int greenValue = (int) (128 + 127 * PApplet.cos(PApplet.radians(valColor - 120)));
    int blueValue = (int) (128 + 127 * PApplet.cos(PApplet.radians(valColor - 240)));
    int currentColor = myParent.color(redValue, greenValue, blueValue); // set de current color
    myParent.tint(currentColor, PApplet.constrain(valColor * 5 * ghostEffectValue / 255, 0, 360)); // apply to the image
  }

  // version with pg for insertion into a PGraphic
  private void colorEffectTint(int valColor, PGraphics pg) {
    valColor = valColor % 360; // limit to 360 for a circle of color
    int redValue = (int) (128 + 127 * PApplet.cos(PApplet.radians(valColor)));
    int greenValue = (int) (128 + 127 * PApplet.cos(PApplet.radians(valColor - 120)));
    int blueValue = (int) (128 + 127 * PApplet.cos(PApplet.radians(valColor - 240)));
    int currentColor = myParent.color(redValue, greenValue, blueValue); // set de current color
    pg.tint(currentColor, PApplet.constrain(valColor * 5 * ghostEffectValue / 255, 0, 360)); // apply to the image
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

  public void showHitbox() {

    // size
    float hL = spriteWidth / 2 + hitboxW; // for changing the hitbox size
    float hH = spriteHeight / 2 + hitboxH;
    float directionSprite1 = 0;

    if (rotationStyle == "all around") {
      directionSprite1 = direction;
    } else {
      directionSprite1 = 0;
    }

    float cx1 = x + hL * PApplet.cos(PApplet.radians(directionSprite1))
        - hH * PApplet.sin(PApplet.radians(directionSprite1));
    float cy1 = y + hL * PApplet.sin(PApplet.radians(directionSprite1))
        + hH * PApplet.cos(PApplet.radians(directionSprite1));
    float cx2 = x - hL * PApplet.cos(PApplet.radians(directionSprite1))
        - hH * PApplet.sin(PApplet.radians(directionSprite1));
    float cy2 = y - hL * PApplet.sin(PApplet.radians(directionSprite1))
        + hH * PApplet.cos(PApplet.radians(directionSprite1));
    float cx3 = x - hL * PApplet.cos(PApplet.radians(directionSprite1))
        + hH * PApplet.sin(PApplet.radians(directionSprite1));
    float cy3 = y - hL * PApplet.sin(PApplet.radians(directionSprite1))
        - hH * PApplet.cos(PApplet.radians(directionSprite1));
    float cx4 = x + hL * PApplet.cos(PApplet.radians(directionSprite1))
        + hH * PApplet.sin(PApplet.radians(directionSprite1));
    float cy4 = y + hL * PApplet.sin(PApplet.radians(directionSprite1))
        - hH * PApplet.cos(PApplet.radians(directionSprite1));

    myParent.push();
    myParent.strokeWeight(4);
    myParent.point(cx1, cy1);
    myParent.point(cx2, cy2);
    myParent.point(cx3, cy3);
    myParent.point(cx4, cy4);
    myParent.pop();
  }

  public void modifyHitboxW(float hw) {
    hitboxW = hw;
  }

  public void modifyHitboxH(float hh) {
    hitboxH = hh;
  }

  public boolean touch(float xx, float yy, float l, float h, float di, String rotationStyleOther) { // square hitbox
    // comparing two
    // position and
    // size
    float hL = spriteWidth / 2 + hitboxW; // for changing the hitbox size
    float hH = spriteHeight / 2 + hitboxH;

    float directionSprite1 = 0;
    float directionSpriteOther = 0;

    if (rotationStyle == "all around") {
      directionSprite1 = direction;
    } else {
      directionSprite1 = 0;
    }
    if (rotationStyleOther == "all around") {
      directionSpriteOther = di;
    } else {
      directionSpriteOther = 0;
    }

    float cx1 = x + hL * PApplet.cos(PApplet.radians(directionSprite1))
        - hH * PApplet.sin(PApplet.radians(directionSprite1));
    float cy1 = y + hL * PApplet.sin(PApplet.radians(directionSprite1))
        + hH * PApplet.cos(PApplet.radians(directionSprite1));
    float cx2 = x - hL * PApplet.cos(PApplet.radians(directionSprite1))
        - hH * PApplet.sin(PApplet.radians(directionSprite1));
    float cy2 = y - hL * PApplet.sin(PApplet.radians(directionSprite1))
        + hH * PApplet.cos(PApplet.radians(directionSprite1));
    float cx3 = x - hL * PApplet.cos(PApplet.radians(directionSprite1))
        + hH * PApplet.sin(PApplet.radians(directionSprite1));
    float cy3 = y - hL * PApplet.sin(PApplet.radians(directionSprite1))
        - hH * PApplet.cos(PApplet.radians(directionSprite1));
    float cx4 = x + hL * PApplet.cos(PApplet.radians(directionSprite1))
        + hH * PApplet.sin(PApplet.radians(directionSprite1));
    float cy4 = y + hL * PApplet.sin(PApplet.radians(directionSprite1))
        - hH * PApplet.cos(PApplet.radians(directionSprite1));
    float[] spriteXx = { cx1, cx2, cx3, cx4 };
    float[] spriteYy = { cy1, cy2, cy3, cy4 };

    float cxother1 = xx + l / 2 * PApplet.cos(PApplet.radians(directionSpriteOther))
        - h / 2 * PApplet.sin(PApplet.radians(directionSpriteOther));
    float cyother1 = yy + l / 2 * PApplet.sin(PApplet.radians(directionSpriteOther))
        + h / 2 * PApplet.cos(PApplet.radians(directionSpriteOther));
    float cxother2 = xx - l / 2 * PApplet.cos(PApplet.radians(directionSpriteOther))
        - h / 2 * PApplet.sin(PApplet.radians(directionSpriteOther));
    float cyother2 = yy - l / 2 * PApplet.sin(PApplet.radians(directionSpriteOther))
        + h / 2 * PApplet.cos(PApplet.radians(directionSpriteOther));
    float cxother3 = xx - l / 2 * PApplet.cos(PApplet.radians(directionSpriteOther))
        + h / 2 * PApplet.sin(PApplet.radians(directionSpriteOther));
    float cyother3 = yy - l / 2 * PApplet.sin(PApplet.radians(directionSpriteOther))
        - h / 2 * PApplet.cos(PApplet.radians(directionSpriteOther));
    float cxother4 = xx + l / 2 * PApplet.cos(PApplet.radians(directionSpriteOther))
        + h / 2 * PApplet.sin(PApplet.radians(directionSpriteOther));
    float cyother4 = yy + l / 2 * PApplet.sin(PApplet.radians(directionSpriteOther))
        - h / 2 * PApplet.cos(PApplet.radians(directionSpriteOther));
    float[] otherXx = { cxother1, cxother2, cxother3, cxother4 };
    float[] otherYy = { cyother1, cyother2, cyother3, cyother4 };

    boolean returnTouch = false;
    /*
     * if (showHitbox) {
     * myParent.push();
     * myParent.strokeWeight(10);
     * myParent.point(cx1, cy1);
     * myParent.point(cx2, cy2);
     * myParent.point(cx3, cy3);
     * myParent.point(cx4, cy4);
     * myParent.pop();
     * }
     */

    for (int i = 0; i < 4; i++) {
      float mx = spriteXx[i] - xx;
      float my = spriteYy[i] - yy;
      float mxRot = mx * PApplet.cos(-PApplet.radians(directionSpriteOther))
          - my * PApplet.sin(-PApplet.radians(directionSpriteOther));
      float myRot = mx * PApplet.sin(-PApplet.radians(directionSpriteOther))
          + my * PApplet.cos(-PApplet.radians(directionSpriteOther));
      float mx2 = otherXx[i] - x;
      float my2 = otherYy[i] - y;
      float mxRot2 = mx2 * PApplet.cos(-PApplet.radians(directionSprite1))
          - my2 * PApplet.sin(-PApplet.radians(directionSprite1));
      float myRot2 = mx2 * PApplet.sin(-PApplet.radians(directionSprite1))
          + my2 * PApplet.cos(-PApplet.radians(directionSprite1));

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
    if (touch(xx, yy, l, h, 0, "don't rotate") && display) {
      return true;
    } else {
      return false;
    }
  }

  public boolean touch(Sprite other) {

    float hL2 = other.spriteWidth + other.hitboxW * 2; // for changing the hitbox size, note divided by 2 and hitbowW is
                                                       // * 2 beacause all is divided inside touch function
    float hH2 = other.spriteHeight + other.hitboxH * 2;

    if (touch(other.x, other.y, hL2, hH2, other.direction, other.rotationStyle) && other.display && display) {
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
      else if (s == "mouse" && touch(myParent.mouseX, myParent.mouseY, 0, 0, 0, "don't rotate")) {
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

  public void askAndWait(String s) { // ask block is a stage function but each sprite call it by this function.
    stageSprite.answer = "";
    if (!stageSprite.isAsking) {
      stageSprite.isAsking = true;
      say(s); // display the question
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
