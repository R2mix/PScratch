package R2mix.PScratch;

import processing.core.PApplet;
import processing.core.PGraphics;

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
