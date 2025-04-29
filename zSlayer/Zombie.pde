class Zombie{
  
  ///////////////
  // variables
  //////////////
  
  float x; 
  float y;
  float d;
  color aColor;
  float xSpeed;
  boolean isActive = true;
 
 float left;
 float right;
 float top;
 float bottom;

 boolean death;

  ////////////
  // constructor
  ////////////
  Zombie(int wave){
    
   x = 800;
   y = (random (220,700));
   
   d = 125; 
   
   aColor = color(0,random(255),0);
   
  xSpeed = 6 + wave * 0.15;

   
    left = x - d/2;
    right = x + d/2;
    top = y - d/2;
    bottom = y + d/2;
    
    death = false;
    
  }
  
  ///////////////////////
  /////// functions
  ///////////////////////
  void render(){
    
   fill(aColor);
 //  circle(x,y,d); 
  zAnimation.isAnimating = true;
  zAnimation.display(int(x), int(y));
    
  }
  
   /*
This function takes updates the position the zombie according to its speed.
   */
  void move() {
   
    x -= xSpeed;
    
    left = x - d/2;
    right = x + d/2;
    top = y - d/2;
    bottom = y + d/2;
    
  }

  /*
  This checks if the zombie is touching the wall and counts it
   */
  void reachedWall() {
  
    if( x +d /2 < 0){
     isActive= false;
     escapedZombies++; 
    }
  }
}
