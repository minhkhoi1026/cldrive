//{"Cluster_Indices":3,"Cluster_Sizes":4,"DATA_D":7,"DATA_H":6,"DATA_W":5,"Mask":1,"TFCE_Values":0,"threshold":2}
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

kernel void CalculateTFCEValues(global float* TFCE_Values, global const float* Mask, private float threshold, global const unsigned int* Cluster_Indices, global const unsigned int* Cluster_Sizes, private int DATA_W, private int DATA_H, private int DATA_D) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  if (Mask[hook(1, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] != 1.0f)
    return;

  if (Cluster_Indices[hook(3, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] < (DATA_W * DATA_H * DATA_D)) {
    float clusterSize = (float)Cluster_Sizes[hook(4, Cluster_Indices[Chook(3, Calculate3DIndex(x, y, z, DATA_W, DATA_H)))];
    float value = sqrt(clusterSize) * threshold * threshold;

    TFCE_Values[hook(0, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] += value;
  }
}