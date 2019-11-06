void keyPressed()
{
    if(key == ' ')
    {
        Input.key_space = true;
    }

    if(keyCode == LEFT)
    {
        Input.key_left = true;
    }
    if(keyCode == RIGHT)
    {
        Input.key_right = true;
    }
}

void keyReleased()
{
    if(key == ' ')
    {
        Input.key_space = false;
    }

    if(keyCode == LEFT)
    {
        Input.key_left = false;
    }
    if(keyCode == RIGHT)
    {
        Input.key_right = false;
    }
}

static class Input
{
  //GLOBALS FOR INPUT//////////////////////////////////////////////////////
  static boolean key_space = false;
  static boolean key_left = false;
  static boolean key_right = false;
//GLOBALS FOR INPUT//////////////////////////////////////////////////////
}
