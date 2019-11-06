static final float INITIAL_UPDATE_THRESHOLD = 0.5f;
static float updateThreshold = INITIAL_UPDATE_THRESHOLD;

static boolean moveInvadersLeft = true;

class Invader
{
    
  
    float x;
    float y;
    
    color c;
    
    boolean isAlive = true;
    
    static final int INVADER_WIDTH  = 32;
    static final int INVADER_HEIGHT = 32;

    
    float elapsed = 0;
  
    Invader(float x, float y, color c)
    {
      this.x = x;
      this.y = y;
      
      this.c = c;
    }
    
    void update(float delta)
    {
        if(elapsed >= updateThreshold)
        {
          elapsed -= updateThreshold;
        
          if(moveInvadersLeft) x -= INVADER_WIDTH / 2f;
          else                 x += INVADER_WIDTH / 2f;
        }
        else
        {
          elapsed += delta;
        }
    }
    
    void render()
    {
      if(isAlive)
      {
        tint(c);
        image(invaderImage, x, y, INVADER_WIDTH, INVADER_HEIGHT);
      }
    }
}
