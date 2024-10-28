//{"DATA_D":3,"DATA_H":2,"Image":1,"Maxs":0}
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

kernel void CalculateRowMaxs(global float* Maxs, global const float* Image, private int DATA_H, private int DATA_D) {
  int z = get_global_id(0);

  if (z >= DATA_D)
    return;

  float max = -10000.0f;
  for (int y = 0; y < DATA_H; y++) {
    max = mymax(max, Image[hook(1, Calculate2DIndex(y, z, DATA_H))]);
  }

  Maxs[hook(0, z)] = max;
}