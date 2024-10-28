//{"DATA_D":6,"DATA_H":5,"DATA_W":4,"Mask":2,"NUMBER_OF_VOLUMES":7,"Transformed_Volumes":0,"Volumes":1,"c_X":3}
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
kernel void TransformData(global float* Transformed_Volumes, global float* Volumes, global const float* Mask, global const float* c_X, private int DATA_W, private int DATA_H, private int DATA_D, private int NUMBER_OF_VOLUMES) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  int3 tIdx = {get_local_id(0), get_local_id(1), get_local_id(2)};

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  if (Mask[hook(2, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] != 1.0f)
    return;

  for (int v = 0; v < NUMBER_OF_VOLUMES; v++) {
    Transformed_Volumes[hook(0, Calculate4DIndex(x, y, z, v, DATA_W, DATA_H, DATA_D))] = 0.0f;

    for (int vv = 0; vv < NUMBER_OF_VOLUMES; vv++) {
      Transformed_Volumes[hook(0, Calculate4DIndex(x, y, z, v, DATA_W, DATA_H, DATA_D))] += c_X[hook(3, vv + v * NUMBER_OF_VOLUMES)] * Volumes[hook(1, Calculate4DIndex(x, y, z, vv, DATA_W, DATA_H, DATA_D))];
    }
  }

  for (int v = 0; v < NUMBER_OF_VOLUMES; v++) {
    Volumes[hook(1, Calculate4DIndex(x, y, z, v, DATA_W, DATA_H, DATA_D))] = Transformed_Volumes[hook(0, Calculate4DIndex(x, y, z, v, DATA_W, DATA_H, DATA_D))];
  }
}