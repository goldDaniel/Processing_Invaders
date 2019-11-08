class Player extends Entity
{
    private float speed = SCREEN_WIDTH;


    Player()
    {
        super(SCREEN_WIDTH / 2 - 16, SCREEN_HEIGHT - 32, 32, 32);
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

    void draw()
    {
        fill(0, 1f, 1f);
        rect(x, y,  WIDTH, HEIGHT);
    }
}
