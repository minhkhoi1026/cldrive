//{"ballPosX":0,"ballPosY":1,"ballVelX":2,"ballVelY":3,"height":5,"input":10,"maxBallSpeed":6,"paddle1Pos":7,"paddle2Pos":8,"paddleHeight":9,"width":4}
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

kernel void get_nn_input_only(global const float* ballPosX, global const float* ballPosY, global const float* ballVelX, global const float* ballVelY, global const int* width, global const int* height, global const int* maxBallSpeed, global const float* paddle1Pos, global const float* paddle2Pos, global const int* paddleHeight, global float* input) {
  if (get_global_id(0) == 0) {
    input[hook(10, 0)] = *ballPosX / *width;
    input[hook(10, 1)] = *ballPosY / *height;
    input[hook(10, 2)] = *ballVelX / *maxBallSpeed;
    input[hook(10, 3)] = *ballVelY / *maxBallSpeed;
    input[hook(10, 4)] = *paddle1Pos / (*height - *paddleHeight);
    input[hook(10, 5)] = 0;
  }
}