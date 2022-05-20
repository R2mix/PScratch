# PScratch-lib-0.8.2

PScratch is a package for processing that give the possibility to use basic scratch function for learning processing

#### Initialization
For start (in futur this will be an importable library), you have ton download PScratch released and use the folling code for starting

```java
Cat cat;                         // create a new sprite
Scene scene;                     // create the scene                         // create a new sprite
void setup() {                   // --- when program starts (like green flag)
  size(800, 600);                // screen size
  scene = new Scene("scenes");   // initialize the scene
  soundFolder("sounds");         // loadSounds into soundsFolder (can be renamed)
  //-----initialize sprites-----------
  cat= new Cat();
}                                // ------end of starting program ------
void draw () {                   //-----forever at 60 fps-----
  scene.backdrops();             // display the backdrops of the scene
  pickColor();
  cat.draw();                    // display a sprite can be also cat.display
}                                //----end of draw -----
void keyPressed() {              // called when a key is pressed
  keyIsDown();                   // check if all keys are pressed or not
}
void keyReleased() {             // called when a key is released
  keyIsUp();                     // check if all keys are released or not
}

class Cat extends Sprite {           // create the sprite instance named "Cat"
  Cat() {
    super();                         //call sprite functions
    start();                         // launch thread run, independent from draw
    spriteFolder("cat");             // look into sprite folder and import image, each sprite MSUT have its own folder named
  }
  void draw() {                      // call it into the main draw void or just call sprite.display into main draw void
    display();                       // for showing and using the sprite
  }
  void run() {                       // thread where you can code without screen frameRate
  }
}
```

#### Motion

| Scratch | Processing | Description|
| :-: | :-: | :-: |
| ![move](web/assets/sprite_move_steps.png) | `move(10);` | how many pixels the sprite move in the current direction|
| ![turn left](web/assets/sprite_turn_left.png) | `turnLeft(15);` | how many degrees the sprite is rotation to the left |
| ![turn right](web/assets/sprite_turn_right.png) | `turnRight(15);` | how many degrees the sprite is rotation to the right |
| ![go to](web/assets/sprite_go_to.png) | `goTo(0, 0);goTo("mouse");goTo("randomPosition");goTo(Sprite);` | Place the sprite somewhere : Can be coordonates x and Y, an other sprite, a random position in the screen or to the mouse |
| ![glide](web/assets/sprite_go_to.png) | `glide(1, 0, 0);glide(1, "mouse");glide(1, "randomPosition");glide(1, Sprite);` | The sprite will move during 1 second somewhere : Can be coordonates x and Y, an other sprite, a random position in the screen or to the mouse (it might not be call in draw void)|
| ![point in direction](web/assets/point_towards.png) | `pointInDirection(0);` | Orienting the sprite in a direction in degrees. 0 is the default orientation |
| ![point towards](web/assets/point_towards.png) | `pointTowards(0,0);pointTowards("mouse");pointTowards(Sprite);` | Orienting the sprite towars a : coordonates x and Y, an other sprite, a random position in the screen or to the mouse |
| ![change x by](web/assets/sprite_change_x_by.png) | `changeXBy(10);` | Change the coodonate X of the sprite in pixel |
| ![set x to](web/assets/sprite_set_x_to.png) | `setXTo(0);` | Set the coodonate X of the sprite in pixel |
| ![change y by](web/assets/sprite_change_y_by.png) | `changeYBy(10);` | Change the coodonate Y of the sprite in pixel |
| ![set y to](web/assets/sprite_set_y_to.png) | `setYTo(0);` | Set the coodonate Y of the sprite in pixel |
| ![on edge bounce](web/assets/sprite_if_on_edge_bounce.png) | `onEdgeBounce();` | If the sprite touch the edge, it will automatically turn in the oposite direction |
| ![x](web/assets/sprite_x_positon.png) | `x` | Return the current coordonate X of the sprite |
| ![y](web/assets/sprite_y_position.png) | `y` | Return the current coordonate Y of the sprite |
| ![direction](web/assets/sprite_direction.png) | `direction` | Return the current direction of the sprite |
| ![set rotation style](web/assets/rotation.png ) | `setRotationStyle("left-right");setRotationStyle("don't rotate");setRotationStyle("all around");` | Change the style of the rotation of the sprite, "left-right" the sprite will move like mirror, "don't rotate" the sprite will no be visualy affected by the orientation and "all around" is the defaut 360° rotation. This is purelly visual and don't affect the mouvements of the sprite |


#### Looks

| Scratch | Processing | Description|
| :-: | :-: | :-: |
| ![say](web/assets/say.png) | `say("Hellow");say("Hellow", 2);` | Display a dialog bubble to the sprite with a text, it's possible to display during a defined time in second (in this case it might not be call in draw void) |
| ![think](web/assets/think.png) | `think("Hellow");think("Hellow", 2);` | Display a thinking bubble to the sprite with a text, it's possible to display during a defined time in second (in this case it might not be call in draw void) |
| ![switch costume to](web/assets/switch_costume.png) | `switchCostumeTo(1);` | Change the sprite costume to a specified costume number |
| ![next costume](web/assets/nextCostume.png) | `nextCostume()` | Change the costume of the sprite to the next costume in the costumes list |
| ![switch backdrop to](web/assets/stage_switch_backdrop_to.png) | `stage.switchBackdropTo(1);` | Change the stage backdrop to a specified backdrop number |
| ![next backdrop](web/assets/stage_next_backdrop.png) | `stage.nextBackdrop();` | Change the stage backdrop to the next backdrop in the backdrops list |
| ![change size by](web/assets/change_size.png) | `changeSizeBy(25);` | Change the size of the sprite to a bigger or , with negativ numbers to a smaller size |
| ![set Size To](web/assets/sprite_set_size_to.png) | `setSizeTo(25);` | Set the size of the sprite in purcent |
| ![change color](web/assets/stage_change_color_by.png) | `changeColorEffectBy(25);` | Change all the color of the sprite to another, each 100 the color will reset from the start |
| ![set color](web/assets/stage_set_color.png) | `setColorEffectTo(0);` | Set all the color of the sprite to another, 0 to 100 |
| ![change ghost](web/assets/stage_change_ghost_by.png) | `changeGhostEffectBy(25);` | Add transparency to the sprite at 255 it will be totally invisible |
| ![set ghost](web/assets/stage_set_ghost.png) | `setGhostEffectTo(10);`  | Set the transparency to the sprite at 255 it will be totally invisible |
| ![clear graphic effect](web/assets/clearGraphics.png) | `clearGraphicEffects();` | Cancel all the graphics effects like color and ghost |
| ![show](web/assets/show.png) | `show();` | Show the sprite and can be detected and can detect other things |
| ![hide](web/assets/hide.png) | `hide();` | Hide the sprite and can't be detected and can't detect other things |
| ![cuurentCostume](web/assets/costume.png) | `costume` | Return the current costume of the sprite |
| ![currentBackdrop](web/assets/stage_backdrop_number.png) | `stage.backdrop` | Return the current backdrop of the stage |
| ![size](web/assets/size.png) | `spriteSize` `spriteWidth` `spriteHeight` | Return the size or the width or the height of the sprite |



#### Sensing

| Scratch | Processing |
| :-: | :-: |
| ![touch](web/assets/touch.png) | `touch(color); touch(Sprite);touch(x,y,l,h);touch("mouse");touch("edge");` |
| ![distanceTo](web/assets/distance.png) | `distanceTo("mouse");distanceTo(Sprite);distanceTo(x, y);` |
| ![set drag mode](web/assets/draggable.png) | `setDragMode(true);` |
| ![mouse down](web/assets/sprite_mouse_down.png) | `mousePressed` |
| ![mouse x](web/assets/sprite_mouse_x.png) | `mouseX` |
| ![mouse y](web/assets/sprite_mouse_y.png) | `mouseY` |
| ![key pressed](web/assets/sprite_key_pressed.png) | `keyIsPressed('a'), keyIsPressed("upArrow")`  |
| ![stage current ?](web/assets/sprite_current_time.png) | `year();`,`month();`, `day();`, `hour();`, `minute();`, `second();`, `millis();` |


#### Sounds

| Scratch | Processing |
| :-: | :-: |
| ![playSoundUntilDown](web/assets/startsoundentirely.png) | `playSoundUntilDown(0);` |
| ![playSound](web/assets/startsound.png) | `playSound(0);` |
| ![stopAllSound](web/assets/stopAllsounds.png) | `stopAllSound();` `stopSound(0);` |
| ![changeSoundEffect](web/assets/changeeffect.png) | `changePitchEffectBy(100);``changePanEffectBy(0);`|
| ![setSoundEffect](web/assets/setEffect.png) | `setPitchEffectBy(10);``setPanEffectBy(0);` |
| ![clearsoundeffect](web/assets/clearsoundeffect.png) | `clearSoundEffects();` |
| ![changeVolumeBy](web/assets/changeVolume.png) | `changeVolumeBy(-10);` |
| ![setVolumeBy](web/assets/setVolume.png) | `setVolumeTo(100);` |
