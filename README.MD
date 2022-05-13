# PScratch-lib-0.8.1

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

| Scratch | Processing |
| :-: | :-: |
| ![move](web/assets/sprite_move_steps.png) | `move(10);` |
| ![turn left](web/assets/sprite_turn_left.png) | `turnLeft(15);` |
| ![turn right](web/assets/sprite_turn_right.png) | `turnRight(15);` |
| ![go to](web/assets/sprite_go_to.png) | `goTo(0, 0);goTo("mouse");goTo("randomPosition");goTo(Sprite);` |
| ![glide](web/assets/sprite_go_to.png) | `glide(0, 0);glide("mouse");glide("randomPosition");glide(Sprite);` |
| ![point in direction](web/assets/sprite_point_in_direction.png) | `pointInDirectionTo(0);` |
| ![point towards](web/assets/sprite_point_in_towards.png) | `pointTowards(0,0);pointTowards("mouse");pointTowards(Sprite);` |
| ![change x by](web/assets/sprite_change_x_by.png) | `changeXBy(10);` |
| ![set x to](web/assets/sprite_set_x_to.png) | `setXTo(0);` |
| ![change y by](web/assets/sprite_change_y_by.png) | `changeYBy(10);` |
| ![set y to](web/assets/sprite_set_y_to.png) | `setYTo(0);` |
| ![on edge bounce](web/assets/sprite_if_on_edge_bounce.png) | `onEdgeBounce();` |
| ![x](web/assets/sprite_x_positon.png) | `x;` |
| ![y](web/assets/sprite_y_position.png) | `y;` |
| ![direction](web/assets/sprite_direction.png) | `direction;` |
| ![set rotation style](web/assets/set_rotation_style.png) | `setRotationStyle("left-right");setRotationStyle("don't rotate");setRotationStyle("all around");` |


#### Looks

| Scratch | Processing |
| :-: | :-: |
| ![say](web/assets/say.png) | `say("Hellow");say("Hellow", 2);` |
| ![think](web/assets/think.png) | `think("Hellow");think("Hellow", 2);` |
| ![switch costume to](web/assets/stage_switch_costume_to.png) | `switchCostumeTo(1)` |
| ![next costume](web/assets/stage_next_costume.png) | `nextCostume()` |
| ![switch backdrop to](web/assets/stage_switch_backdrop_to.png) | `stage.switchBackdropTo(1)` |
| ![next backdrop](web/assets/stage_next_backdrop.png) | `stage.nextBackdrop()` |
| ![change size by](web/assets/change_size_by.png) | `changeSizeBy(25)` |
| ![set Size To](web/assets/set_size_to.png) | `setSizeTo(25)` |
| ![change color](web/assets/stage_change_color_by.png) | `changeColorEffectBy(25)` |
| ![set color](web/assets/stage_set_color.png) | `setColorEffectTo(0)` |
| ![change ghost](web/assets/stage_change_ghost_by.png) | `changeGhostEffectBy(25)` |
| ![set ghost](web/assets/stage_set_ghost.png) | `setGhostEffectTo(10)` |
| ![clear graphic effect](web/assets/clear_graphic_effect.png) | `clearGraphicEffects()` |
| ![show](web/assets/show.png) | `show()` |
| ![hide](web/assets/hide.png) | `hide()` |
| ![ currentBackdrop](web/assets/stage_backdrop_number.png) | `stage.backdrop()` |
