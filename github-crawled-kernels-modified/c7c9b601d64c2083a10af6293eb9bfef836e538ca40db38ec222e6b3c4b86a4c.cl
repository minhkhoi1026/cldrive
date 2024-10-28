//{"ballPosX":1,"ballPosY":2,"ballRad":5,"ballVelX":3,"ballVelY":4,"currentPlayer":15,"height":7,"maxBallSpeed":8,"output":13,"output_size":14,"paddle1Pos":9,"paddle2Pos":10,"paddleHeight":12,"paddleSpeed":11,"reward":17,"speedIncreaseFac":16,"time":0,"width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int whoHasWon(global const float* ballPosX, global const int* ballRad, global const int* width, global const float* ballVelX) {
  if (*ballPosX + *ballRad >= *width && *ballVelX > 0)
    return -1;
  else if (*ballPosX <= 0 && *ballVelX < 0)
    return 1;
  else
    return 0;
}

void reset(global float* ballPosX, global float* ballPosY, global float* ballVelX, global float* ballVelY, global const int* ballRad, global const int* width, global const int* height, global const int* maxBallSpeed, global const int* minBallSpeed, global float* paddle1Pos, global float* paddle2Pos, float rand1, float rand2, float rand3, float rand4) {
  *ballPosX = *width / 2;
  *ballPosY = *height / 2;

  *ballVelX = rand1 * (*maxBallSpeed - *minBallSpeed) / 8.0f + *minBallSpeed;
  if (rand2 > 0.5f)
    *ballVelX *= -1;

  *ballVelY = rand3 * (*maxBallSpeed - *minBallSpeed) / 8.0f + *minBallSpeed;
  if (rand4 > 0.5f)
    *ballVelY *= -1;

  *paddle1Pos = *height / 2;
  *paddle2Pos = *height / 2;
}

void movePaddle(int dir, global const int* currentPlayer, global float* paddle1Pos, global float* paddle2Pos, global const int* paddleSpeed, global const int* height, global const int* paddleHeight) {
  if (*currentPlayer == 1) {
    if (dir == 1)
      *paddle1Pos += *paddleSpeed;
    else if (dir == -1)
      *paddle1Pos -= *paddleSpeed;
    *paddle1Pos = max(0.0f, min((float)(*height - *paddleHeight), *paddle1Pos));
  } else {
    if (dir == 1)
      *paddle2Pos += *paddleSpeed;
    else if (dir == -1)
      *paddle2Pos -= *paddleSpeed;
    *paddle2Pos = max(0.0f, min((float)(*height - *paddleHeight), *paddle2Pos));
  }
}

void executeCompareAI(global const float* ballPosY, global const int* paddleHeight, global int* currentPlayer, global float* paddle1Pos, global float* paddle2Pos, global const int* paddleSpeed, global const int* height) {
  if (*ballPosY > *paddle2Pos + *paddleHeight / 2)
    movePaddle(1, currentPlayer, paddle1Pos, paddle2Pos, paddleSpeed, height, paddleHeight);
  else
    movePaddle(-1, currentPlayer, paddle1Pos, paddle2Pos, paddleSpeed, height, paddleHeight);
}

void advanceBallWithoutCollision(float fac, global float* ballPosX, global float* ballPosY, global const float* ballVelX, global const float* ballVelY) {
  *ballPosX += *ballVelX * fac;
  *ballPosY += *ballVelY * fac;
}

void advanceBall(float fac, global float* ballPosX, global float* ballPosY, global float* ballVelX, global float* ballVelY, global const int* ballRad, global const int* width, global const int* height, global const int* maxBallSpeed, global const float* paddle1Pos, global const float* paddle2Pos, global const float* speedIncreaseFac, global const int* paddleHeight) {
  float nextBallPosX = *ballPosX + *ballVelX * fac;
  float nextBallPosY = *ballPosY + *ballVelY * fac;

  float colTimeX = 0, colTimeY = 0;

  if (nextBallPosY <= 0 && *ballVelY < 0)
    colTimeY = *ballPosY / -*ballVelY;

  if (nextBallPosY + *ballRad >= *height && *ballVelY > 0)
    colTimeY = (*height - (*ballPosY + *ballRad)) / *ballVelY;

  if (nextBallPosX <= 0 && *ballVelX < 0)
    colTimeX = *ballPosX / -*ballVelX;

  if (nextBallPosX + *ballRad >= *width && *ballVelX > 0)
    colTimeX = (*width - (*ballPosX + *ballRad)) / *ballVelX;

  if (colTimeX > 0 && (colTimeY == 0 || colTimeX <= colTimeY)) {
    advanceBallWithoutCollision(colTimeX, ballPosX, ballPosY, ballVelX, ballVelY);
    if ((*ballVelX > 0 && *ballPosY + *ballRad >= *paddle1Pos && *ballPosY <= *paddle1Pos + *paddleHeight) || (*ballVelX < 0 && *ballPosY + *ballRad >= *paddle2Pos && *ballPosY <= *paddle2Pos + *paddleHeight)) {
      *ballVelX *= -1;

      if (fabs(*ballVelX * *speedIncreaseFac) < *maxBallSpeed && fabs(*ballVelY * *speedIncreaseFac) < *maxBallSpeed) {
        *ballVelX *= *speedIncreaseFac;
        *ballVelY *= *speedIncreaseFac;
      }
    } else {
      advanceBallWithoutCollision(fac - colTimeX, ballPosX, ballPosY, ballVelX, ballVelY);
    }
  } else if (colTimeY > 0) {
    advanceBallWithoutCollision(colTimeY, ballPosX, ballPosY, ballVelX, ballVelY);
    *ballVelY *= -1;

  } else
    advanceBallWithoutCollision(fac, ballPosX, ballPosY, ballVelX, ballVelY);
}

kernel void interpret_nn_output(global int* time, global float* ballPosX, global float* ballPosY, global float* ballVelX, global float* ballVelY, global const int* ballRad, global const int* width, global const int* height, global const int* maxBallSpeed, global float* paddle1Pos, global float* paddle2Pos, global const float* paddleSpeed, global const int* paddleHeight, global const char* output, unsigned int output_size, global int* currentPlayer, global const float* speedIncreaseFac, global float* reward) {
  if (get_global_id(0) == 0) {
    if (output[hook(13, 0)])
      movePaddle(1, currentPlayer, paddle1Pos, paddle2Pos, paddleSpeed, height, paddleHeight);
    else if ((output_size > 1 && output[hook(13, 1)]) || (output_size == 1 && !output[hook(13, 0)]))
      movePaddle(-1, currentPlayer, paddle1Pos, paddle2Pos, paddleSpeed, height, paddleHeight);

    *currentPlayer = -1;
    executeCompareAI(ballPosY, paddleHeight, currentPlayer, paddle1Pos, paddle2Pos, paddleSpeed, height);
    advanceBall(1, ballPosX, ballPosY, ballVelX, ballVelY, ballRad, width, height, maxBallSpeed, paddle1Pos, paddle2Pos, speedIncreaseFac, paddleHeight);

    *time++;
    *reward = whoHasWon(ballPosX, ballRad, width, ballVelX);
  }
}