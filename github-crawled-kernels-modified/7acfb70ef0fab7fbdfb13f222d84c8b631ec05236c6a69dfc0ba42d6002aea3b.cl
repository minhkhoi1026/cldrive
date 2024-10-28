//{"DATA_D":5,"DATA_H":4,"DATA_W":3,"Thresholded_Volume":0,"Volume":1,"threshold":2}
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

float mymax(float a, float b) {
  if (a > b)
    return a;
  else
    return b;
}

kernel void ThresholdVolume(global float* Thresholded_Volume, global const float* Volume, private float threshold, private int DATA_W, private int DATA_H, private int DATA_D) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  if (Volume[hook(1, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] > threshold) {
    Thresholded_Volume[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = 1.0f;
  } else {
    Thresholded_Volume[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = 0.001f;
  }
}