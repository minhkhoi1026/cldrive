//{"DATA_D":3,"DATA_H":2,"DATA_W":1,"NUMBER_OF_VOLUMES":4,"Volumes":0}
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

kernel void RemoveMean(global float* Volumes, private int DATA_W, private int DATA_H, private int DATA_D, private int NUMBER_OF_VOLUMES) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  float mean = 0.0f;
  for (int v = 0; v < NUMBER_OF_VOLUMES; v++) {
    mean += Volumes[hook(0, Calculate4DIndex(x, y, z, v, DATA_W, DATA_H, DATA_D))];
  }
  mean /= (float)NUMBER_OF_VOLUMES;

  for (int v = 0; v < NUMBER_OF_VOLUMES; v++) {
    Volumes[hook(0, Calculate4DIndex(x, y, z, v, DATA_W, DATA_H, DATA_D))] -= mean;
  }
}