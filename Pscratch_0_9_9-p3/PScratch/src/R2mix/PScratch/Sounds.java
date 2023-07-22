package R2mix.PScratch;

import java.io.File;
import processing.core.PApplet;
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
