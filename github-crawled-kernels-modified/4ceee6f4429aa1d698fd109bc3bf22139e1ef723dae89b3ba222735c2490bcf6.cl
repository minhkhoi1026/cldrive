//{"DATA_D":6,"DATA_H":5,"DATA_T":7,"DATA_W":4,"Filter_Response":0,"Volume":1,"c_Smoothing_Filter_X":2,"t":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int Calculate2DIndex(int x, int y, int DATA_W) {
  return x + y * DATA_W;
}

int Calculate3DIndex(int x, int y, int z, int DATA_W, int DATA_H) {
  return x + y * DATA_W + z * DATA_W * DATA_H;
}

int Calculate4DIndex(int x, int y, int z, int t, int DATA_W, int DATA_H, int DATA_D) {
  return x + y * DATA_W + z * DATA_W * DATA_H + t * DATA_W * DATA_H * DATA_D;
}
kernel void SeparableConvolutionColumnsGlobalMemory(global float* Filter_Response, global float* Volume, constant float* c_Smoothing_Filter_X, private int t, private int DATA_W, private int DATA_H, private int DATA_D, private int DATA_T) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if ((x >= DATA_W) || (y >= DATA_H) || (z >= DATA_D))
    return;

  int3 tIdx = {get_local_id(0), get_local_id(1), get_local_id(2)};

  float sum = 0.0f;
  float pixel;

  int xoff = -4;
  for (int fx = 8; fx >= 0; fx--) {
    if (((x + xoff) >= 0) && ((x + xoff) < DATA_W)) {
      pixel = Volume[hook(1, Calculate3DIndex(x + xoff, y, z, DATA_W, DATA_H))];
    } else {
      pixel = 0.0f;
    }

    sum += pixel * c_Smoothing_Filter_X[hook(2, fx)];
    xoff++;
  }

  Filter_Response[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = sum;
}