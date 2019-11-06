class Player
{
  
    private float speed = SCREEN_WIDTH;

    float x;
    float y;

    final float WIDTH = 32;
    final float HEIGHT = 32;

    Player()
    {
        x = SCREEN_WIDTH /  2 - WIDTH / 2;
        y = SCREEN_HEIGHT - HEIGHT;
    }

    void update(float dt)
    {
        if(Input.key_left)
        {
            x -= speed * dt;
        }
        if(Input.key_right)
        {
            x += speed * dt;
        }

        if(x < 0) x = 0;
        if(x > SCREEN_WIDTH - WIDTH) x = SCREEN_WIDTH - WIDTH;


        if(Input.key_space)
        {   
            bullet.fire(x + WIDTH / 2, y + HEIGHT);
        }
    }

    void render()
    {
        fill(0, 1f, 1f);
        rect(x, y,  WIDTH, HEIGHT);
    }
}
