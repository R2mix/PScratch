# PScratch-lib-0.9.1

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

### Motion

| Scratch___________________________ | Processing | Description|
| :---  | :--- | :--- |
| ![move](web/assets/sprite_move_steps.png)| `move(10);` | how many pixels the sprite move in the current direction|
| ![turn left](web/assets/sprite_turn_left.png) | `turnLeft(15);` | how many degrees the sprite is rotation to the left |
| ![turn right](web/assets/sprite_turn_right.png) | `turnRight(15);` | how many degrees the sprite is rotation to the right |
| ![go to](web/assets/sprite_go_to.png) | `goTo(0, 0); goTo("mouse"); goTo("randomPosition"); goTo(Sprite);` | Place the sprite somewhere : Can be coordinates x and Y, an other sprite, a random position in the screen or to the mouse |
| ![glide](web/assets/sprite_go_to.png) | `glide(1, 0, 0); glide(1, "mouse"); glide(1, "randomPosition"); glide(1, Sprite);` | The sprite will move during 1 second somewhere : Can be coordinates x and Y, an other sprite, a random position in the screen or to the mouse (it might not be call in draw void)|
| ![point in direction](web/assets/point_towards.png) | `pointInDirection(0);` | Orienting the sprite in a direction in degrees. 0 is the default orientation |
| ![point towards](web/assets/point_towards.png) | `pointTowards(0,0); pointTowards("mouse"); pointTowards(Sprite);` | Orienting the sprite towars a : coordinates x and Y, an other sprite, a random position in the screen or to the mouse |
| ![change x by](web/assets/sprite_change_x_by.png) | `changeXBy(10);` | Change the coodonate X of the sprite in pixel |
| ![set x to](web/assets/sprite_set_x_to.png) | `setXTo(0);` | Set the coodonate X of the sprite in pixel |
| ![change y by](web/assets/sprite_change_y_by.png) | `changeYBy(10);` | Change the coodonate Y of the sprite in pixel |
| ![set y to](web/assets/sprite_set_y_to.png) | `setYTo(0);` | Set the coodonate Y of the sprite in pixel |
| ![on edge bounce](web/assets/sprite_if_on_edge_bounce.png) | `onEdgeBounce();` | If the sprite touch the edge, it will automatically turn in the oposite direction |
| ![x](web/assets/sprite_x_positon.png) | `x` | Return the current coordinate X of the sprite |
| ![y](web/assets/sprite_y_position.png) | `y` | Return the current coordinate Y of the sprite |
| ![direction](web/assets/sprite_direction.png) | `direction` | Return the current direction of the sprite |
| ![set rotation style](web/assets/rotation.png ) | `setRotationStyle("left-right"); setRotationStyle("don't rotate"); setRotationStyle("all around");` | Change the style of the rotation of the sprite, "left-right" the sprite will move like mirror, "don't rotate" the sprite will no be visualy affected by the orientation and "all around" is the defaut 360° rotation. This is purelly visual and don't affect the mouvements of the sprite |


### Looks

| Scratch | Processing | Description |
| :--- | :--- | :--- |
| ![say](web/assets/say.png) | `say("Hellow"); say("Hellow", 2);` | Display a dialog bubble to the sprite with a text, it's possible to display during a defined time in second (in this case it might not be call in draw void) |
| ![think](web/assets/think.png) | `think("Hellow"); think("Hellow", 2);` | Display a thinking bubble to the sprite with a text, it's possible to display during a defined time in second (in this case it might not be call in draw void) |
| ![switch costume to](web/assets/switch_costume.png) | `switchCostumeTo(1);` | Change the sprite costume to a specified costume number |
| ![next costume](web/assets/nextCostume.png) | `nextCostume()` | Change the costume of the sprite to the next costume in the costumes list |
| ![switch backdrop to](web/assets/stage_switch_backdrop_to.png) | `stage.switchBackdropTo(1);` | Change the stage backdrop to a specified backdrop number |
| ![next backdrop](web/assets/stage_next_backdrop.png) | `stage.nextBackdrop();` | Change the stage backdrop to the next backdrop in the backdrops list |
| ![change size by](web/assets/change_size.png) | `changeSizeBy(25);` | Change the size of the sprite to a bigger or , with negativ numbers to a smaller size. In case of BIG size, it's better to resize the image with `resize()` function or a image edition software. |
| ![set Size To](web/assets/sprite_set_size_to.png) | `setSizeTo(25);` | Set the size of the sprite in purcent. In case of BIG size, it's better to resize the image with `resize()` function or a image edition software. |
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


### Sounds

| Scratch___________________________  | Processing | Description |
| :--- | :--- | :--- |
| ![playSoundUntilDown](web/assets/startsoundentirely.png) | `playSoundUntilDown(0);` | Play a sound and wait until is finished. It should be call inside run() function |
| ![playSound](web/assets/startsound.png) | `playSound(0);` | Play a sound. If the sound is called again it will stop, rewind and play it again |
| ![stopAllSound](web/assets/stopAllsounds.png) | `stopAllSound();` `stopSound(0);` | Stop all sound, stop a specific sound |
| ![changeSoundEffect](web/assets/changeeffect.png) | `changePitchEffectBy(100);` `changePanEffectBy(0);`| Change the pitch effect to positive or negative. Change the left-right panning of a sound (Only work with monophonics sounds) |
| ![setSoundEffect](web/assets/setEffect.png) | `setPitchEffectBy(10);``setPanEffectBy(0);` | Set the value of the pitch or the pan effect |
| ![clearsoundeffect](web/assets/clearsoundeffect.png) | `clearSoundEffects();` | Set default value to all sound effect |
| ![changeVolumeBy](web/assets/changeVolume.png) | `changeVolumeBy(-10);` | Change the volume of the sounds |
| ![setVolumeBy](web/assets/setVolume.png) | `setVolumeTo(100);` | Set value to the volume of the sounds |
| ![volume](web/assets/volume.png) | `volume;` | return value of the volume of the sounds |


### Control

| Scratch___________________________  | Processing | Description |
| :--- | :--- | :--- |
| ![wait](web/assets/wait.png) | `wait(1);` | Stop the code during seconds. It should be call inside `run()` function or it will block the frameRate |
| ![repeat](web/assets/repeat.png) | `for(int i = 0; i < 10; i++){//code goes here});` | Repeat the code inside few time. `In draw()` void, it will wait the end of the repetition before go to the next frame. In `run()` void, it will repeat independently of the framerate  |
| ![forever](web/assets/forever.png) | `for(;;){//code goes here}` | Work as the repeat 10 time but indefinitly |
| ![if](web/assets/if.png) | `if(//condition){//code goes here}`| Execute the code inside the if, if the condition is complete |
| ![if, else](web/assets/else.png) | `if(//condition){//code goes here}`| Execute the code inside the `if`, if the condition is complete. If the condition is not complete, it will execute the code inside `else`. |
| ![while](web/assets/while.png) | `while(//condition){//code goes here}` | Wait or repeat until condition is done. It should be call inside `run()` function |
| ![Stop](web/assets/stop.png) | `stop(); exit()` | Stop the code, quit the program |
| ![clones](web/assets/clones.png) | ` ArrayList<SpriteClass> SpriteClassArray = new ArrayList<SpriteClass>();` <br><br>  `SpriteClassArray.add(new SpriteClass());` <br><br>  `for (int i = SpriteClassArray.size() - 1; i >= 0; i--) { }` <br><br>  `SpriteClass SpriteClassInstance = SpriteClassArray.get(i);` <br><br>  `SpriteClassInstance.draw();` | The array that contains the class to clone <br><br><br>   Add a new class instance in the ArrayList <br><br>   Iterate for each clones <br><br><br>    Get the current clone instance <br><br><br>   Display each clone | 
     

### Sensing

| Scratch___________________________  | Processing | Description |
| :--- | :--- | :--- |
| ![touch](web/assets/touch.png) | `touch(color); touch(Sprite); touch(x,y,l,h); touch("mouse");touch("edge");` | Return true if the sprite is detecting a color, another sprite, coordinates with a rectangle hitbox, the mouse or the edge of the screen. Should use inside a `if` condition. |
| ![distanceTo](web/assets/distance.png) | `distanceTo("mouse"); distanceTo(Sprite); distanceTo(x, y);` | Return the distance between the center of the sprite and the mouse, a sprite or coordinates |
| ![Ask](web/assets/ask.png) | `ask("Question ?");`  | The sprite will ask to the user a key typed question to the user. |
| ![answer](web/assets/answer.png) | `answer`  | Return the answer of the ask function |
| ![key pressed](web/assets/sprite_key_pressed.png) | `keyIsPressed('a'), keyIsPressed("upArrow")`  | Return true if the named key is pressed. For the arrows, it have to be a string `upArrow, leftArrow, downArrow, rightArrow`. |
| ![mouse down](web/assets/sprite_mouse_down.png) | `mousePressed` | Return true if the mouse is pressed. It should be called inside a `if` |
| ![mouse x](web/assets/sprite_mouse_x.png) | `mouseX` | Return the x position of the mouse on the screen |
| ![mouse y](web/assets/sprite_mouse_y.png) | `mouseY` | Return the y position of the mouse on the screen |
| ![set drag mode](web/assets/draggable.png) | `setDragMode(true);` | Allow user to click and move the sprite with the mouse |
| ![loudness](web/assets/loudness.png) | `loudness` | Return the volume of the microphone 0 - 100 |
| ![timer](web/assets/timer.png) | `timer` | Return the time in sec since programme starts ou being reset|
| ![resetTimer](web/assets/resetTimer.png) | `resetTimer();` | Reset timer to 0|
| ![time](web/assets/sprite_current_time.png) | `year();`,`month();`, `day();`, `hour();`, `minute();`, `second();`, `millis();` | Return the current year, month, day... |



### PEN

| Scratch___________________________  | Processing | Description |
| :--- | :--- | :--- |
| ![pen attach]() | `attach(Sprite);` | Attach the pen to a sprite and follow him |
| ![pen erase all](web/assets/pen_erase_all.png) | `eraseAll();` | Erase all stamp and all pen trace |
| ![stamp](web/assets/stamp.png) | `stamp();` | Make a stamp from the attached sprite |
| ![pen down](web/assets/pen_pen_down.png) | `penDown();` | Allow drawing |
| ![pen up](web/assets/pen_pen_up.png) | `penUp();` | Disable drawing |
| ![pen change color by](web/assets/pen_change_pen_color_by.png) | `changePenColorBy(1);` | Change the color to next color |
| ![pen set color to](web/assets/pen_set_pen_color_to.png) | `setPenColorTo(10);` | Set the color of the pen 0-100 |
| ![pen change transparency by](web/assets/pen_change_pen_transparency_by.png) | `changePenTransparencyBy(1);` | change the transparency of the pen |
| ![pen set transparency to](web/assets/pen_set_pen_transparency_to.png) | `setPenTransparencyTo(50);` | set the transparency of the pen |
| ![pen change size by](web/assets/pen_change_pen_size_by.png) | `changePenSizeBy(1);` | change the size of the pen |
| ![pen set size to](web/assets/pen_set_pen_size_to.png) | `setPenSizeTo(50);` | set the size of the pen |
