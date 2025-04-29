class Bullet{
  
  //variables
  
  int x;
  int y;
  int h;
  int w;
  int speed;
  
  int left; 
  int right;
  int top;
  int bottom;
 
 boolean   shouldRemove;
  //constructor
  Bullet (int startingX, int startingY) {
    
    x = startingX;
    y  = startingY;
    h = 5;
    w = 5;
    speed = 30;
    shouldRemove = false;
    
    left = x - w/2;
    right = x + w/2;
    top = y - h/2;
    bottom = y + h/2;
  }
  
  void render(){
    rect(x,y,w,h,100);
    
  
}
 
 void move(){
 x +=speed;
   
    left = x - w/2;
    right = x + w/2;
    top = y - h/2;
    bottom = y + h/2;
 }
 
 void checkRemove(){
 if (x >width + w){
  
   shouldRemove = true;
   
   
 }
}

void shootEnemy(Zombie aZombie){
  if (aZombie.left <= x && x <= aZombie.right &&
      aZombie.top  <= y && y <= aZombie.bottom &&
      aZombie.death == false) {
    
    aZombie.death = true;
    shouldRemove = true;
    count++;
  }
}
}
