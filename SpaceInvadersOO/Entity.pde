abstract class Entity
{
  float x; 
  float y;
  
  final float WIDTH;
  final float HEIGHT;
  
  Entity(float x, float y, float w, float h)
  {
    this.x = x;
    this.y = y;
    this.WIDTH = w;
    this.HEIGHT = h;
  }

  abstract void update(float dt);
  abstract void draw();
  
  
  boolean isColliding(Entity other)
  {
    boolean result = false;
    
    if(x < other.x + other.WIDTH && x + WIDTH > other.x && 
       y < other.y + other.HEIGHT &&
       y + HEIGHT > other.y)
     {
       result = true;
     }
    
    return result;
  }
}
