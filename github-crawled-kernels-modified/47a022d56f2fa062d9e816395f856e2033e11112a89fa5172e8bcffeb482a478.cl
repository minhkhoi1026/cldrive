//{"Cluster_Indices":2,"Cluster_Sizes":3,"DATA_D":10,"DATA_H":9,"DATA_W":8,"Mask":4,"NUMBER_OF_PERMUTATIONS":11,"P_Values":0,"Test_Values":1,"c_Max_Values":5,"contrast":7,"threshold":6}
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

kernel void CalculatePermutationPValuesClusterMassInference(global float* P_Values, global const float* Test_Values, global const unsigned int* Cluster_Indices, global const unsigned int* Cluster_Sizes, global const float* Mask, global const float* c_Max_Values, private float threshold, private int contrast, private int DATA_W, private int DATA_H, private int DATA_D, private int NUMBER_OF_PERMUTATIONS) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int z = get_global_id(2);

  if (x >= DATA_W || y >= DATA_H || z >= DATA_D)
    return;

  if (Mask[hook(4, Calculate3DIndex(x, y, z, DATA_W, DATA_H))] == 1.0f) {
    if (Test_Values[hook(1, Calculate4DIndex(x, y, z, contrast, DATA_W, DATA_H, DATA_D))] > threshold) {
      float Test_Value = ((float)Cluster_Sizes[hook(3, Cluster_Indices[Chook(2, Calculate3DIndex(x, y, z, DATA_W, DATA_H)))]) / 10000.0f;

      float sum = 0.0f;
      for (int p = 0; p < NUMBER_OF_PERMUTATIONS; p++) {
        if (Test_Value > c_Max_Values[hook(5, p)]) {
          sum += 1.0f;
        }
      }
      P_Values[hook(0, Calculate4DIndex(x, y, z, contrast, DATA_W, DATA_H, DATA_D))] = sum / (float)NUMBER_OF_PERMUTATIONS;
    }

    else {
      P_Values[hook(0, Calculate4DIndex(x, y, z, contrast, DATA_W, DATA_H, DATA_D))] = 0.0f;
    }
  } else {
    P_Values[hook(0, Calculate4DIndex(x, y, z, contrast, DATA_W, DATA_H, DATA_D))] = 0.0f;
  }
}