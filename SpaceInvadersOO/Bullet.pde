class Bullet
{
    private boolean active = false;

    final float SPEED = SCREEN_HEIGHT;

    float x = -100;
    float y = -100;

    final float WIDTH = 8;
    final float HEIGHT = 32;

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
