//GAMESTATE VARIABLES/////////////////////////////////////
float prevTime;

boolean gameOver = false;
//GAMESTATE VARIABLES/////////////////////////////////////

//SCREEN BOUND VARIABLES//////////////////////////////////////
int SCREEN_WIDTH = 800;
int SCREEN_HEIGHT = 600; 
//SCREEN BOUND VARIABLES//////////////////////////////////////


//GLOBALS FOR INVADERS///////////////////////////////////////
Invader[][] invaders;

static PImage invaderImage;

static final float INITIAL_UPDATE_THRESHOLD = 0.5f;
static float updateThreshold = INITIAL_UPDATE_THRESHOLD;
static boolean moveInvadersLeft = true;
//GLOBALS FOR INVADERS///////////////////////////////////////

Player player;

Bullet bullet;

Shield[] shields;

void setup()
{
  //sets our screen size
  size(800, 600);

  //makes images not blurry
  smooth(0);
  
  colorMode(HSB, 360f, 1f, 1f, 1f);

  //loads our image files
  initAssets();

  //initializes space invader assets
  initInvaders();
  
  //creates bullet
  bullet = new Bullet();

  //creates player
  player = new Player();
  
  
  int numShields = 4;
  shields = new Shield[numShields];
  for(int i = 0; i < shields.length; i++)
  {
    float increment = 1f / (numShields + 1);
    shields[i] = new Shield(increment * (i + 1) * SCREEN_WIDTH - 32, SCREEN_HEIGHT * 4f / 5f);  
  }
  
  prevTime = millis();
}

void initAssets()
{
   invaderImage = loadImage("Invader.png"); 
}


void draw()
{
  float currentTime = millis();
  float dt = (currentTime - prevTime) / 1000f;
  prevTime = currentTime;

  if(!gameOver)
  {
    update(dt);
  }
  
  //DRAW GAME//////////////////////////////////////////////////////////
  background(0);
  for(int i = 0; i < invaders.length; i++)
  {
    for(int j = 0; j < invaders[i].length; j++)
    {
      invaders[i][j].draw();
    }
  }

  for(int i = 0; i < shields.length; i++)
  {
    shields[i].draw();  
  }
  
  bullet.draw();
  player.draw();
  
  //if the game is over we draw the end text
  if(gameOver)
  {
    boolean win = true;
    //count alive invaders so we can see tell if we won or not
    for(int i = 0; i < invaders.length && win; i++)
    {
      for(int j = 0; j < invaders[i].length && win; j++)
      {
        if(invaders[i][j].isAlive)
        {
          win = false;
        }
      }
    }
    
     textAlign(CENTER);
     fill(0f, 0f, 1f);
     textSize(64);
     text("GAME OVER", SCREEN_WIDTH / 2, SCREEN_HEIGHT/ 2);
     
     if(win)
     {
       text("YOU WIN!", SCREEN_WIDTH / 2, SCREEN_HEIGHT/ 2 + 64);
     }
     else
     {
       text("YOU LOSE!", SCREEN_WIDTH / 2, SCREEN_HEIGHT/ 2 + 64);
     }  
  }
  //DRAW GAME//////////////////////////////////////////////////////////
}
 
 
void update(float dt)
{
  updateInvaders(dt); 
  player.update(dt);
  
  bullet.update(dt);
  if(bullet.active)
  {  
    doBulletCollisions();
  }
  
  for(int i = 0; i < shields.length; i++)
  {
    shields[i].update(dt);  
  }
  
}

void doBulletCollisions()
{
  //this lets us exit the loop early once we have detected collision
  boolean collision = false;
  for(int i = 0; i < invaders.length && !collision; i++)
  {
    for(int j = 0; j < invaders[i].length && !collision; j++)
    {
      //if the invader is alive, 
      //we check to see if the bullet rectangle is inside one of the invaders
      //if it is, we set the bullet to inactive and 
      //set the invaders isAlive value to false
      if(invaders[i][j].isAlive)
      {
        if(bullet.isColliding(invaders[i][j]))
        {
          collision = true;
          bullet.active = false;
          invaders[i][j].isAlive = false;
        }
      }
    }
  }
}

void initInvaders()
{
  //creates a new grid of invaders, 
  //and spaces them evenly in the middle of the screen
  int invadersX = 12;
  int invadersY = 5;
  
  float invaderWidth = 32;
  float invaderHeight = 32;
  
  invaders = new Invader[invadersX][invadersY];
  for(int i = 0; i < invadersX; i++)
  {
    for(int j = 0; j < invadersY; j++)
    {
      float x = i * invaderWidth * 1.25f;
      x += SCREEN_WIDTH / 4f;
      float y = j * invaderHeight * 1.25f;
      y += SCREEN_HEIGHT/ 8f;
      invaders[i][j] = new Invader(x, y, color(float(j) / (invadersY) * 360f, 1f, 1f));
    }
  }
}

void updateInvaders(float dt)
{
  //we use these 2 variables to calculate the invader movement speed 
  float initialInvaders = invaders.length * invaders[0].length;
  float currInvaders = 0;
  
  //UPDATE INVADERS//////////////////////////////////////////////////////
  for(int i = 0; i < invaders.length; i++)
  {
    for(int j = 0; j < invaders[i].length; j++)
    {
      if(invaders[i][j].isAlive)
      {
        invaders[i][j].update(dt);
        currInvaders++;
        
        if(player.isColliding(invaders[i][j]))
        {
          gameOver = true;
        }
      }
    }
  }
  
  //this increases the speed the invaders move as less are alive
  float percentageOfInvadersAlive = currInvaders / initialInvaders;
  updateThreshold = percentageOfInvadersAlive * INITIAL_UPDATE_THRESHOLD;  
  
  
  //if we are moving the invaders left we only check collisions with the left hand side
  if(moveInvadersLeft)
  {
    checkInvadersLeftCollision();
    
  }
  //if we are moving the invaders right we only check collisions with the right hand side 
  else
  {
    checkInvaderRightCollision();
    
  }
  
  if(currInvaders == 0)
  {
    gameOver = true;
  }
}


void checkInvadersLeftCollision()
{
  boolean complete = false;
  for(int i = 0; i < invaders.length && !complete; i++)
  {
    for(int j = 0; j < invaders[i].length && !complete; j++)
    {
      if(invaders[i][j].isAlive && invaders[i][j].x <= 0)
      {
        complete = true;
        moveInvadersLeft = false;

        moveInvadersDown();
      }
    } 
  } 
}

void checkInvaderRightCollision()
{
  boolean complete = false;
  for(int i = invaders.length - 1; i >= 0 && !complete; i--)
  {
    for(int j = 0; j < invaders[i].length && !complete; j++)
    {
      if(invaders[i][j].isAlive && invaders[i][j].x + invaders[i][j].WIDTH >= SCREEN_WIDTH)
      {
        complete = true;
        moveInvadersLeft = true;

        moveInvadersDown();
      }
    } 
  }  
}

void moveInvadersDown()
{
  for(int i = 0; i < invaders.length; i++)
  {
    for(int j = 0; j < invaders[i].length; j++)
    {
      invaders[i][j].y += invaders[i][j].HEIGHT / 2f;
    } 
  }
}
