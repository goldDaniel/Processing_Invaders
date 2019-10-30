
//GLOBALS FOR INPUT//////////////////////////////////////////////////////
boolean key_space = false;
boolean key_left = false;
boolean key_right = false;
//GLOBALS FOR INPUT//////////////////////////////////////////////////////

//GLOBALS FOR GAME STATE////////////////////////////////////////////////
float prevTime;
float dt;


final float SCREEN_WIDTH = 800;
final float SCREEN_HEIGHT = 600;

float titleHue;
boolean inMenu = true;

int score = 0;

boolean gameOver = false;
float gameOverTimer = 3;
//GLOBALS FOR GAME STATE////////////////////////////////////////////////


//GLOBALS FOR THE INVADERS////////////////////////////////////////////////
PImage invaderImage;

final int NUM_INVADERS = 8;

float[] invaderX;
float[] invaderY;
boolean[] invaderAlive;

final int INVADER_WIDTH  = 32;
final int INVADER_HEIGHT = 32;

final int INVADER_MOVE_AMOUNT = 48;

final float INITIAL_TIME_UNTIL_MOVE = 0.75f;
float invaderTimeUntilMove = INITIAL_TIME_UNTIL_MOVE;
float invaderMovementTimer = 0;


boolean moveLeft = false;
//GLOBALS FOR THE INVADERS////////////////////////////////////////////////


//GLOBALS FOR PLAYER////////////////////////////////////////////////////
final float PLAYER_WIDTH = 32;
final float PLAYER_HEIGHT = 32;

float playerX;
float playerY;
//GLOBALS FOR PLAYER/////////////////////////////////////////////////////

//GLOBALS FOR BULLET////////////////////////////////////////////////////
boolean bulletInUse = false;

float bulletX = -1;
float bulletY = -1;

float BULLET_WIDTH = 4;
float BULLET_HEIGHT = 16;
//GLOBALS FOR BULLET////////////////////////////////////////////////////

void setup()
{
    size(800, 600);

    smooth(0);    
    colorMode(HSB, 360f, 1f, 1f, 1f);
    prevTime = millis();

    initGame();
    invaderImage = loadImage("Invader.png");
}

void initGame()
{
    invaderX = new float[NUM_INVADERS];
    invaderY = new float[NUM_INVADERS];
    invaderAlive = new boolean[NUM_INVADERS];
    float startX = SCREEN_WIDTH / 2 - (NUM_INVADERS / 2 * (INVADER_WIDTH + INVADER_WIDTH / 2));
    for(int i = 0; i < NUM_INVADERS; i++)
    {
        invaderAlive[i] = true;
        invaderX[i] = startX + i  * INVADER_MOVE_AMOUNT;
        invaderY[i] = INVADER_MOVE_AMOUNT;
    }

    playerX = SCREEN_WIDTH / 2 - PLAYER_WIDTH / 2;
    playerY = SCREEN_HEIGHT - PLAYER_HEIGHT - PLAYER_HEIGHT / 2;
    bulletInUse = false;
    gameOver = false;
    inMenu = true;
    gameOverTimer = 3;
    score = 0;
}

void draw()
{
    //UPDATING GAME/////////////////////////
    float currentTime = millis();
    dt = currentTime - prevTime;

    dt /= 1000;

    prevTime = currentTime;

    if(inMenu)
    {
        
        if(key_space)
        {
            inMenu = false;
        }
    }
    else
    {
        if(!gameOver)
        {
            updateGameplay();
        }
    }
    //UPDATING GAME/////////////////////////


    //DRAWING GAME//////////////////////////
    background(0);
    
    if(inMenu)
    {
        drawMainMenu();
    }
    else
    {
        drawGameplay();    

        int aliveInvaders = 0;
        for(int i = 0; i < NUM_INVADERS; i++)
        {
            if(invaderAlive[i]) aliveInvaders++;
        }
        if(gameOver && aliveInvaders == 0)
        {
            textAlign(CENTER);
            textSize(48);
            text("YOU WIN!", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
            gameOverTimer -= dt;   
        }
        else if(gameOver && aliveInvaders > 0)
        {
            textAlign(CENTER);
            textSize(48);
            text("YOU LOSE!", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
            gameOverTimer -= dt;
        }

        if(gameOverTimer <= 0) initGame();
    }
    //DRAWING GAME//////////////////////////
}

void updateGameplay()
{
    updateInvaders();
    updatePlayer();
    updateBullet();
}

void updateBullet()
{

    if(bulletInUse)
    {
        final float BULLET_SPEED = SCREEN_HEIGHT * dt;
        bulletY -= BULLET_SPEED;

        //check for collisions with invaders
        boolean doneCollision = false;
        for(int i = 0; i < NUM_INVADERS && !doneCollision; i++)
        {
            if(invaderAlive[i])
            {
                if(abs(bulletX - invaderX[i]) * 2 < (BULLET_WIDTH + INVADER_WIDTH) && 
                abs(bulletY - invaderY[i]) * 2 < (BULLET_HEIGHT + INVADER_HEIGHT))
                {
                    doneCollision = true;
                    invaderAlive[i] = false;
                    bulletInUse = false;

                    score += 50;
                }
            }
        }

        //if the bullet goes off screen we are no longer using it
        if(bulletY < 0) bulletInUse = false;
    }
}

void updatePlayer()
{
    final float PLAYER_SPEED = SCREEN_WIDTH * dt;
    if(key_left)
    {
        playerX -= PLAYER_SPEED;
    }
    if(key_right)
    {
        playerX += PLAYER_SPEED;
    }

    if(key_space)
    {
        fireBullet();
    }

    //make sure player cant go off screen
    if(playerX < 0) playerX = 0;
    if(playerX > SCREEN_WIDTH - PLAYER_WIDTH) playerX = SCREEN_WIDTH - PLAYER_WIDTH;
}

void fireBullet()
{
    if(!bulletInUse)
    {
        bulletInUse = true;
        bulletX = playerX + PLAYER_WIDTH / 2 - BULLET_WIDTH / 2;
        bulletY = playerY;
    }
}

void updateInvaders()
{
    //update invader speed depending on how many are left
    int aliveInvaders = 0;
    for(int i = 0; i < NUM_INVADERS; i++)
    {
        if(invaderAlive[i]) aliveInvaders++;
    }

    invaderTimeUntilMove = INITIAL_TIME_UNTIL_MOVE * (float)aliveInvaders / (float)NUM_INVADERS;
    

    if(invaderMovementTimer < invaderTimeUntilMove)
    {
        invaderMovementTimer += dt;
    }
    else
    {
        invaderMovementTimer = 0;

        doInvaderMovement();
        checkInvaderWallCollisions();
    }

    if(aliveInvaders == 0)
    {
        gameOver = true;
    }
    else
    {
        for(int i = 0; i < NUM_INVADERS; i++)
        {
            if(invaderAlive[i]) 
            {
                if(invaderY[i] > SCREEN_HEIGHT - INVADER_HEIGHT * 2)
                {
                    gameOver = true;
                }
            }
        }
    }
}

void doInvaderMovement()
{
    //Move invaders  horizontally
    for(int i = 0; i < NUM_INVADERS; i++)
    {
        if(moveLeft)
        {
            invaderX[i] += INVADER_MOVE_AMOUNT;
        }
        else
        {
            invaderX[i] -= INVADER_MOVE_AMOUNT;
        }
    }
}

void checkInvaderWallCollisions()
{
    //next we check to see if they hit the bounds of the screen
    if(invaderX[0] < 0)
    {
        moveLeft = true;
        //correct all invader positions they move off screen
        for(int i = 0; i < NUM_INVADERS; i++)
        {
            invaderX[i] = i * INVADER_MOVE_AMOUNT + INVADER_WIDTH;
            invaderY[i] += INVADER_HEIGHT;
        }
    }
    //next we check to see if they hit the bounds of the screen
    if(invaderX[NUM_INVADERS - 1] > SCREEN_WIDTH -  INVADER_WIDTH)
    {
        moveLeft = false;
        //correct all invader positions they move off screen
        for(int i = 0; i < NUM_INVADERS; i++)
        {
            invaderX[i] = SCREEN_WIDTH - (NUM_INVADERS - i) * INVADER_MOVE_AMOUNT - INVADER_WIDTH;
            invaderY[i] += INVADER_HEIGHT;
        }
    }
}


void drawGameplay()
{
    //DRAW INVADERS///////////////////////////////////////////////////////
    for(int i = 0; i < NUM_INVADERS; i++)
    {
        if(invaderAlive[i])
        {
            image(invaderImage, invaderX[i], invaderY[i], INVADER_WIDTH, INVADER_HEIGHT);
        }
    }
    //DRAW INVADERS///////////////////////////////////////////////////////
    
    //DRAW BULLET////////////////////////////////////////////////////////
    if(bulletInUse)
    {
        fill(0, 0, 1);
        rect(bulletX, bulletY, BULLET_WIDTH, BULLET_HEIGHT);
    }
    //DRAW BULLET////////////////////////////////////////////////////////

    //DRAW PLAYER/////////////////////////////////////////////////////////
    fill(0, 1, 1);
    rect(playerX, playerY, PLAYER_WIDTH, PLAYER_HEIGHT);
    //DRAW PLAYER/////////////////////////////////////////////////////////

    //DRAW SCORE//////////////////////////////////////////////////////////
    textAlign(LEFT, TOP);
    fill(0, 0, 1);
    text("SCORE: " + score, 0, 0);
    //DRAW SCORE//////////////////////////////////////////////////////////
}

void drawMainMenu()
{
    titleHue += 60f * dt;
    
    textAlign(CENTER);

    fill(titleHue, 1, 1);
    textSize(72);
    text("SPACE INVADERS", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 8);

    textSize(32);
    fill(0, 0, 1);
    text("LEFT / RIGHT ARROWS TO MOVE", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 6 + 48);
    text("SPACEBAR TO SHOOT", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 6 + 48*2);


    fill(0, 0, 1);
    textSize(48);
    text("PRESS SPACEBAR TO START", SCREEN_WIDTH / 2, SCREEN_HEIGHT - SCREEN_HEIGHT / 4);
}


void keyPressed()
{
    if(key == ' ')
    {
        key_space = true;
    }

    if(keyCode == LEFT)
    {
        key_left = true;
    }
    if(keyCode == RIGHT)
    {
        key_right = true;
    }
}

void keyReleased()
{
    if(key == ' ')
    {
        key_space = false;
    }

    if(keyCode == LEFT)
    {
        key_left = false;
    }
    if(keyCode == RIGHT)
    {
        key_right = false;
    }
}