class Player{
  
 // int variables
 
 int x;
 int y;
 
 int w;
 int h;
 
 float speed = 12.5;
 
 boolean moveUp = false;
 boolean moveDown = false;
 boolean moveLeft = false;
 boolean moveRight = false;

 
 int right;
 int top;
 int bottom;
 
 // Constructor
 Player(int startX, int startY){
   x = startX;
   y = startY;
  hitBox();
   w = 1;
   h = 1;
 }
 
 
void move(){
  if (moveUp && y - speed > 0){
    y -= speed;
  }
  if (moveDown && y + h + speed < height){
    y += speed;
  }
  if (moveLeft && x - speed > 0){
    x -= speed;
  }
  if (moveRight && x + w + speed < width){
    x += speed;
  }
  hitBox();
}
 
 void render (){
  fill(255);
  rect(x,y,w,h);
   
   
 }
 
 void hitBox(){
  right = x + w;
  top = y;
  bottom = y + h;
  
   
 }
 
void pressKey(int key) {
  if (key == 'w') moveUp = true;
  if (key == 's') moveDown = true;
  if (key == 'a') moveLeft = true;
  if (key == 'd') moveRight = true;
}

void releaseKey(int key) {
  if (key == 'w') moveUp = false;
  if (key == 's') moveDown = false;
  if (key == 'a') moveLeft = false;
  if (key == 'd') moveRight = false;
}
}
