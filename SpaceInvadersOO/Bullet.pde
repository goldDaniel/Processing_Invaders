class Bullet extends Entity
{
    private boolean active = false;

    final float SPEED = SCREEN_HEIGHT;
    
    Bullet()
    {
      super(-100, -100, 8, 32);  
    }

    void fire(float x, float y)
    {
        if(!active)
        {
            active = true;
            this.x = x - WIDTH / 2;
            this.y = y;
        }
    }

    void update(float dt)
    {       
        if(active)
        {
            y -= SPEED * dt;

            if(y < 0) active = false;
        }
        else
        {
            if(Input.key_space)
            {
                bullet.fire(player.x + player.WIDTH / 2, player.y);
            }
        }
    }

    void draw()
    {
        if(active)
        {
            fill(0f, 0f, 1f);
            rect(x, y, WIDTH, HEIGHT);
        }
    }
}
