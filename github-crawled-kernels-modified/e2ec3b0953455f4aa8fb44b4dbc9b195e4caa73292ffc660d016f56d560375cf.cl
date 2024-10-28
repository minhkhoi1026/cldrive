//{"backwardMapX":6,"backwardMapX_step":16,"backwardMapY":7,"backwardMapY_step":17,"backwardMotionX":2,"backwardMotionX_step":12,"backwardMotionY":3,"backwardMotionY_step":13,"forwardMapX":4,"forwardMapX_step":14,"forwardMapY":5,"forwardMapY_step":15,"forwardMotionX":0,"forwardMotionX_col":9,"forwardMotionX_row":8,"forwardMotionX_step":10,"forwardMotionY":1,"forwardMotionY_step":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void buildMotionMapsKernel(global float* forwardMotionX, global float* forwardMotionY, global float* backwardMotionX, global float* backwardMotionY, global float* forwardMapX, global float* forwardMapY, global float* backwardMapX, global float* backwardMapY, int forwardMotionX_row, int forwardMotionX_col, int forwardMotionX_step, int forwardMotionY_step, int backwardMotionX_step, int backwardMotionY_step, int forwardMapX_step, int forwardMapY_step, int backwardMapX_step, int backwardMapY_step) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < forwardMotionX_col && y < forwardMotionX_row) {
    float fx = forwardMotionX[hook(0, y * forwardMotionX_step + x)];
    float fy = forwardMotionY[hook(1, y * forwardMotionY_step + x)];

    float bx = backwardMotionX[hook(2, y * backwardMotionX_step + x)];
    float by = backwardMotionY[hook(3, y * backwardMotionY_step + x)];

    forwardMapX[hook(4, y * forwardMapX_step + x)] = x + bx;
    forwardMapY[hook(5, y * forwardMapY_step + x)] = y + by;

    backwardMapX[hook(6, y * backwardMapX_step + x)] = x + fx;
    backwardMapY[hook(7, y * backwardMapY_step + x)] = y + fy;
  }
}