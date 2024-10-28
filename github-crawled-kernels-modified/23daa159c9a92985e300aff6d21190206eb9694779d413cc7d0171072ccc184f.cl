//{"ballPosX":2,"ballPosY":3,"ballRad":6,"ballVelX":4,"ballVelY":5,"currentPlayer":19,"height":8,"input":18,"maxBallSpeed":9,"maxTime":1,"minBallSpeed":10,"paddle1Pos":11,"paddle2Pos":12,"paddleHeight":13,"rand1":14,"rand2":15,"rand3":16,"rand4":17,"time":0,"width":7}
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

kernel void get_nn_input(global int* time, global const int* maxTime, global float* ballPosX, global float* ballPosY, global float* ballVelX, global float* ballVelY, global const int* ballRad, global const int* width, global const int* height, global const int* maxBallSpeed, global const int* minBallSpeed, global float* paddle1Pos, global float* paddle2Pos, global const int* paddleHeight, float rand1, float rand2, float rand3, float rand4, global float* input, global int* currentPlayer) {
  if (get_global_id(0) == 0) {
    if (whoHasWon(ballPosX, ballRad, width, ballVelX) != 0 || *time >= *maxTime || *time == -1) {
      *time = 0;
      reset(ballPosX, ballPosY, ballVelX, ballVelY, ballRad, width, height, maxBallSpeed, minBallSpeed, paddle1Pos, paddle2Pos, rand1, rand2, rand3, rand4);
    }
    *currentPlayer = 1;

    input[hook(18, 0)] = *ballPosX / *width;
    input[hook(18, 1)] = *ballPosY / *height;
    input[hook(18, 2)] = *ballVelX / *maxBallSpeed;
    input[hook(18, 3)] = *ballVelY / *maxBallSpeed;
    input[hook(18, 4)] = *paddle1Pos / (*height - *paddleHeight);
    input[hook(18, 5)] = 0;
  }
}