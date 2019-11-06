//to calculate delta time/////////////////////////////////////
float prevTime;
//to calculate delta time/////////////////////////////////////

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


void setup()
{
  //sets our screen size
  size(800, 600);

  //makes images not blurry
  smooth(0);
  
  colorMode(HSB, 360f, 1f, 1f);

  //loads our image files
  initAssets();

  //initializes space invader assets
  initInvaders();
  
  //creates bullet
  bullet = new Bullet();

  //creates player
  player = new Player();
  
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

  update(dt);
  
  
  background(0);
  for(int i = 0; i < invaders.length; i++)
  {
    for(int j = 0; j < invaders[i].length; j++)
    {
      invaders[i][j].draw();
    }
  }

  bullet.draw();
  player.draw();
}
 
 
void update(float dt)
{
  updateInvaders(dt); 
  player.update(dt);

  if(Input.key_space)
  {
    bullet.fire(player.x + player.WIDTH / 2, player.y);
  }

  bullet.update(dt);
  if(bullet.active)
  {  
    doBulletCollisions();
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
        if(bullet.x < invaders[i][j].x + Invader.INVADER_WIDTH &&
           bullet.x + bullet.WIDTH > invaders[i][j].x && 
           bullet.y < invaders[i][j].y + Invader.INVADER_HEIGHT &&
           bullet.y + bullet.HEIGHT > invaders[i][j].y)
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
  int invadersX = 8;
  int invadersY = 5;
  invaders = new Invader[invadersX][invadersY];
  for(int i = 0; i < invadersX; i++)
  {
    for(int j = 0; j < invadersY; j++)
    {
      float x = i * Invader.INVADER_WIDTH * 1.5f;
      x += SCREEN_WIDTH / 4f;
      float y = j * Invader.INVADER_HEIGHT * 1.5f;
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
      }
    }
  }

  //this increases the speed the invaders move as less are alive
  float percentageOfInvadersAlive = currInvaders / initialInvaders;
  updateThreshold = percentageOfInvadersAlive * INITIAL_UPDATE_THRESHOLD;  
  
  //if we are moving the invaders left we only check collisions with the left hand side
  if(moveInvadersLeft)
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
  //if we are moving the invaders right we only check collisions with the right hand side 
  else
  {
    boolean complete = false;
    for(int i = 0; i < invaders.length && !complete; i++)
    {
      for(int j = 0; j < invaders[i].length && !complete; j++)
      {
        if(invaders[i][j].isAlive && invaders[i][j].x + Invader.INVADER_WIDTH >= SCREEN_WIDTH)
        {
          complete = true;
          moveInvadersLeft = true;

          moveInvadersDown();
        }
      } 
    }
  }bullet.update(dt);
}

void moveInvadersDown()
{
  for(int i = 0; i < invaders.length; i++)
  {
    for(int j = 0; j < invaders[i].length; j++)
    {
      invaders[i][j].y += Invader.INVADER_HEIGHT / 2f;
    } 
  }
}
