// Orlando Santiago
// Final projcet

/////////////// Global Vars ///////////////////////////

Animation guyAnimation;
Animation zAnimation;
Animation fAnimation;

PImage[] guyImages = new PImage[6];
PImage[] zImages = new PImage[5];
PImage[] fImages = new PImage[8];

import processing.sound.*;
SoundFile backgroundMu;
SoundFile gunSound;

Player player;
ArrayList<Bullet> bulletList;
ArrayList<Zombie> zombieList;

PImage back;
PImage zBack;
PImage titleC;
PImage endC;

int spawnInterval = 5000;
int baseTime = 0;
int wave = 0;
int count = 0;

int state = 0;
int escapedZombies = 0;

PFont font;

//////////////////// Setup Func ////////////////////////////
void setup() {
  size(800, 800);
  font = createFont("Alkhemikal.ttf",128);
  
  player = new Player(50, height / 2);
  zombieList = new ArrayList<Zombie>();
  bulletList = new ArrayList<Bullet>();

  gunSound = new SoundFile(this, "1418_gunshot-01.mp3");
  backgroundMu = new SoundFile(this, "backgroundmsc.mp3");

  for (int i = 0; i < guyImages.length; i++) {
    guyImages[i] = loadImage("shoot" + i + ".png");
  }

  guyAnimation = new Animation(guyImages, .5, 5);
  back = loadImage("b1.png");
  zBack = loadImage ("zBack.png");
  titleC = loadImage ("titleCard0.png");
  endC = loadImage ("end0.png");
  
  zAnimation = new Animation(zImages, .02, 6);
  fAnimation = new Animation(fImages, .09, 2);

  for (int i = 0; i < zImages.length; i++) {
    zImages[i] = loadImage("z" + i + ".png");
  }

  for (int i = 0; i < fImages.length; i++) {
    fImages[i] = loadImage("fire" + i + ".png");
  }
}

/////////// Draw Loop and Main Game func /////////////////////
void draw() {
  textFont(font);
  
  if (!backgroundMu.isPlaying()) {
        backgroundMu.play(); }
        
  switch (state) {

//////////////////  State  0: Start Screen ///////////////////
    case 0:
      background(zBack);
      titleC.resize(500,300);
      image (titleC, 140, 100);
      fill(255);
      textAlign(CENTER);
      textSize(32);
      text("Press r to Start", width / 2, height / 2);
      textSize(18);
      text("Press i for Instructions", width / 2, height / 2 + 40);
      break;

    ////////////// State 1: GAME!!!!! //////////////////////////////
    case 1:
      background(back);
      
/////////////////// fire animation  ////////////////////////////////

   //   fAnimation.isAnimating = true;
     // fAnimation.display(350, 50);
    //  fAnimation.display(300, 500);
    //  fAnimation.display(200, 300);
    //  fAnimation.display(700, 300);
      
      player.move();
      player.render();
      gunSound.rate(2);

     

//////////////////// bullets  /////////////////////////////////

      for (Bullet aBullet : bulletList) {
        aBullet.render();
        aBullet.move();
        aBullet.checkRemove();
        for (Zombie aZombie : zombieList) {
          aBullet.shootEnemy(aZombie);
        }
      }

      for (int i = bulletList.size() - 1; i >= 0; i--) {
        if (bulletList.get(i).shouldRemove) {
          bulletList.remove(i);
        }
      }

      for (int i = zombieList.size() - 1; i >= 0; i--) {
        if (zombieList.get(i).death) {
          zombieList.remove(i);
        }
      }

      ArrayList<Zombie> activeZombies = new ArrayList<Zombie>();
      for (Zombie z : zombieList) {
        z.move();
        z.reachedWall();

        if (z.isActive) {
          z.render();
          activeZombies.add(z);
        }
      }
      zombieList = activeZombies;

      zombieWave();

    

////////////// Player Animation  ////////////////////////////////////
      guyAnimation.display(player.x + 30, player.y + 25);

////////////// kills Tracker ////////////////////////////////////////
      fill(255);
      textSize(50);
      text("Kills: " + count, 100, 40);
 ///////// zombie tracker ///////////////////////////////////////////
 if (escapedZombies >= 3) {
  state = 2;
}
 
      break;

////////////// State 2: Dead ////////////////////////////////

    case 2:
    background(back);
      endC.resize(500,300);
     image (endC, 400, 190);
      
      fill(255, 0, 0);
      textAlign(CENTER);
      textSize(32);
      text("Game Over", width / 2, height / 2 - 40);
      textSize(24);
      text("You killed " + count + " zombies", width / 2, height / 2);
      text("Press r to Restart", width / 2, height / 2 + 60);
      break;
  
  //////////////// State 3 : Instruvtions ///////////////////////////
  
  case 3:
  background(zBack);
  fill(255);
  textAlign(CENTER);
  textSize(24);
  text("W, A, S, and D = Move", width / 2, height / 2 - 40);
  text("Spacebar = Shoot", width / 2, height / 2);
  text("Don't let 3 zombies reach the left wall!", width / 2, height / 2 + 40);
  text("Press r to begin", width / 2, height / 2 + 80);
  break;
}
}
/////////// Key Tracking ////////////////////////////////////////////

void keyPressed() {
  if (state == 1) {
    player.pressKey(key);

    if (key == ' ') {
      bulletList.add(new Bullet(player.x + 50, player.y - 5));

      if (gunSound.isPlaying()) {
        gunSound.stop();
      }

      gunSound.play();
      guyAnimation.isAnimating = true;
    }
  }

  if (state == 0 && key == 'r') {
    state = 1;
  }
 if (state == 0 && key == 'i') {
    state = 3; 
  }
      if (state == 3 && key == 'r') {
  restartGame();
}
 if (state == 2 && key == 'r') {
  restartGame();
}
}
void keyReleased() {
  if (state == 1) {
    player.releaseKey(key);
  }

}



/////////// Zombie Wave  ////////////////////////////////////////

void zombieWave() {
  int currentTime = millis();

  if (currentTime - baseTime >= spawnInterval) {
    wave++;
    int zombieCounter = int(random(1 + wave, 2 + wave));
    int attempts = 0;

    while (zombieList.size() < zombieCounter && attempts < 100) {
      Zombie newZombie = new Zombie(wave);
      boolean tooClose = false;

      for (Zombie existing : zombieList) {
        float distance = dist(newZombie.x, newZombie.y, existing.x, existing.y);
        float minDist = (newZombie.d + existing.d) / 2;

        if (distance < minDist) {
          tooClose = true;
          break;
        }
      }

      if (tooClose == false) {
        zombieList.add(newZombie);
      }

      attempts++;
    }

    baseTime = currentTime;
  }
}
////////////////// Game Restart /////////////////////////////////

void restartGame() {
  zombieList.clear();         
  bulletList.clear();      
  player = new Player(50, height / 2); 
  wave = 0;                   
  count = 0;                  
  baseTime = millis();     
  escapedZombies = 0;      
  state = 1;            
}
