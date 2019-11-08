class Shield extends Entity
{
 
  float health = 1f;  
  
  Shield(float x, float y)
  {
    super(x, y, 64, 64);
  }
  
  void update(float dt)
  {
    if(health > 0)
    {
      if(bullet.active && bullet.isColliding(this))
      {
        bullet.active = false;
        health -= 0.1f;
      }
      
      boolean complete = false;
      for(int i = 0; i < invaders.length && !complete; i++)
      {
        for(int j = 0; j < invaders[i].length && !complete; j++)
        {
          
          if(invaders[i][j].isAlive && invaders[i][j].isColliding(this))
          {
            complete = true;
            this.health = 0;
          }
        }
      }
    }
    
    if(health < 0) health = 0;
  }
  
  void draw()
  {
      fill(120, 1f, 1f, health);
      rect(x, y, WIDTH, HEIGHT);
  }
}
