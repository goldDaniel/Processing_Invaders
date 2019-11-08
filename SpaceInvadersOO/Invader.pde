class Invader extends Entity
{  
    color c;
    
    boolean isAlive = true;
    
    float elapsed = 0;
  
  
  
    Invader(float x, float y, color c)
    {
      super(x, y, 32f, 32f);
      
      this.c = c;
    }
    
    void update(float delta)
    {
        if(elapsed >= updateThreshold)
        {
          elapsed -= updateThreshold;
        
          if(moveInvadersLeft) 
            x -= WIDTH / 2f;
          else                 
            x += WIDTH / 2f;
        }
        else
        {
          elapsed += delta;
        }
    }
    
    void draw()
    {
      if(isAlive)
      {
        tint(c);
        image(invaderImage, x, y, WIDTH, HEIGHT);
      }
    }
}
