//{"Cluster_Indices":0,"Cluster_Masses":1,"DATA_D":8,"DATA_H":7,"DATA_W":6,"Data":2,"Mask":3,"contrast":5,"threshold":4}
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

bool IsInsideVolume(int x, int y, int z, int DATA_W, int DATA_H, int DATA_D) {
  if (z < 0)
    return false;
  else if (z >= DATA_D)
    return false;
  else if (y < 0)
    return false;
  else if (y >= DATA_H)
    return false;
  else if (x < 0)
    return false;
  else if (x >= DATA_W)
    return false;
  else
    return true;
}

kernel void CalculateClusterMasses(global unsigned int* Cluster_Indices, volatile global unsigned int* Cluster_Masses, global const float* Data, global const float* Mask, private float threshold, private int contrast, private int DATA_W, private int DATA_H, private int DATA_D) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  if (Mask[hook(3, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] != 1.0f)
    return;

  if (Data[hook(2, Calculate4DIndex(x, y, z, contrast, DATA_W, DATA_H, DATA_D))] > threshold) {
    atomic_add(&Cluster_Masses[hook(1, Cluster_Indices[Chook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H)))], (unsigned int)(Data[hook(2, Calculate4DIndex(x, y, z, contrast, DATA_W, DATA_H, DATA_D))] * 10000.0f));
  }
}