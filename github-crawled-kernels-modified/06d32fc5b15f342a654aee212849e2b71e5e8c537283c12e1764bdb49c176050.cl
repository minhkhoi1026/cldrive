//{"DATA_D":5,"DATA_H":4,"DATA_W":3,"Mask":2,"Volume":1,"max_value":0}
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

kernel void CalculateMaxAtomic(volatile global int* max_value, global const float* Volume, global const float* Mask, private int DATA_W, private int DATA_H, private int DATA_D) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  if (Mask[hook(2, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] != 1.0f)
    return;

  int value = (int)(Volume[hook(1, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] * 10000.0f);
  atomic_max(max_value, value);
}