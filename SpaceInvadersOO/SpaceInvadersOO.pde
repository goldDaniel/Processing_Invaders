float prevTime;
int SCREEN_WIDTH = 800;
int SCREEN_HEIGHT = 600; 

Invader[][] invaders;

Player player;
Bullet bullet;


void setup()
{
  size(800, 600);

  smooth(0);
  colorMode(HSB, 360f, 1f, 1f, 1f);

  initAssets();
  initInvaders();
  
  bullet = new Bullet();
  player = new Player();
  
  prevTime = millis();
}

void draw()
{
  float currentTime = millis();
  float dt = (currentTime - prevTime) / 1000f;
  prevTime = currentTime;

  update(dt);
  render();
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
  boolean collision = false;
  for(int i = 0; i < invaders.length && !collision; i++)
  {
    for(int j = 0; j < invaders[i].length && !collision; j++)
    {
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

void render()
{
  background(0);
  for(int i = 0; i < invaders.length; i++)
  {
    for(int j = 0; j < invaders[i].length; j++)
    {
      invaders[i][j].render();
    }
  }

  bullet.render();
  player.render();
}



void initInvaders()
{
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

  updateThreshold = currInvaders / initialInvaders * INITIAL_UPDATE_THRESHOLD;  

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
