//{"Cluster_Indices":0,"DATA_D":7,"DATA_H":6,"DATA_W":5,"Data":1,"Mask":2,"contrast":4,"threshold":3}
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

kernel void SetStartClusterIndicesKernel(global unsigned int* Cluster_Indices, global const float* Data, global const float* Mask, private float threshold, private int contrast, private int DATA_W, private int DATA_H, private int DATA_D) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  if ((Mask[hook(2, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] == 1.0f) && (Data[hook(1, Calculate4DIndex(x, y, z, contrast, DATA_W, DATA_H, DATA_D))] > threshold)) {
    Cluster_Indices[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = (unsigned int)Calculate3DIndex(x, y, z, DATA_W, DATA_H);
  } else {
    Cluster_Indices[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] = (unsigned int)(DATA_W * DATA_H * DATA_D * 3);
  }
}