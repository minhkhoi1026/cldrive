//{"array":17,"inputvalues":16,"local1":2,"local2":3,"maxZ":8,"originX":13,"originY":14,"originZ":15,"outputBuffer":4,"reconDimX":5,"reconDimY":6,"search":0,"searchIdx":1,"searchLen":7,"sigma":9,"voxelSpacingX":10,"voxelSpacingY":11,"voxelSpacingZ":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 getPointFromArray(global float* inputvalues, int i) {
  unsigned long idx = i;
  float4 voxel = (float4){inputvalues[hook(16, idx * 3)], inputvalues[hook(16, (idx * 3) + 1)], inputvalues[hook(16, (idx * 3) + 2)], 0};
  return voxel;
}

float4 getPointFromSearchArray(global const float* inputvalues, int i) {
  unsigned long idx = i;
  float4 voxel = (float4){inputvalues[hook(16, idx * 5)], inputvalues[hook(16, (idx * 5) + 1)], inputvalues[hook(16, (idx * 5) + 2)], 0};
  return voxel;
}

void setPointToArray(global float* array, int x, int y, int z, unsigned int yPitch, unsigned int zPitch, float4 vector) {
  unsigned long idx = z * zPitch + y * yPitch + x;
  array[hook(17, idx * 3)] = vector.x;
  array[hook(17, idx * 3 + 1)] = vector.y;
  array[hook(17, idx * 3 + 2)] = vector.z;
}

kernel void evaluateParzenLocal(global const float* search, global const int* searchIdx, global const float* local1, global const float* local2, global float* outputBuffer, int reconDimX, int reconDimY, int searchLen, int maxZ, float sigma, float voxelSpacingX, float voxelSpacingY, float voxelSpacingZ, float originX, float originY, float originZ) {
  int gidx = get_group_id(0);
  int gidy = get_group_id(1);
  int lidx = get_local_id(0);
  int lidy = get_local_id(1);

  int locSizex = get_local_size(0);
  int locSizey = get_local_size(1);

  int gloSizex = get_global_size(0);
  int gloSizey = get_global_size(1);

  unsigned int x = gidx * locSizex + lidx;
  unsigned int y = gidy * locSizey + lidy;

  unsigned int yPitch = gloSizex;
  unsigned int zPitch = gloSizex * gloSizey;

  if (x >= reconDimX || y >= reconDimY)
    return;

  float xcoord = (x * voxelSpacingX) + originX;
  float ycoord = (y * voxelSpacingY) + originY;
  int z = maxZ;
  float zcoord = (z * voxelSpacingZ) + originZ;
  float4 summation = (float4){0, 0, 0, 0};
  float4 initial = (float4){xcoord, ycoord, zcoord, 0};
  float weightsum = 0;
  float factor = -0.5f / (sigma * sigma);
  int closePoint = -1;
  float dist = 100000;
  for (int i = 0; i < searchLen; i++) {
    float4 from = getPointFromArray(search, i);
    float dist2 = distance(from, initial);
    if (dist2 < dist) {
      dist = dist2;
      closePoint = i;
    }
  }
  if (closePoint == -1)
    return;
  int start = (int)searchIdx[hook(1, closePoint * 2)];
  int len = (int)searchIdx[hook(1, closePoint * 2 + 1)];
  float acc = 70;
  for (int i = start; i < start + len; i++) {
    float4 from = getPointFromArray(local1, i);
    float4 to = getPointFromArray(local2, i);
    float4 direction = to - from;
    float dist = distance(from, initial);
    float weight = exp((factor * dist * dist) + acc);
    weightsum += weight;
    summation += (direction * weight);
  }
  if (fabs(weightsum) > 0.00000001) {
    summation /= weightsum;
  } else {
    summation = (float4){0, 0, 0, 0};
  }
  setPointToArray(outputBuffer, x, y, z, yPitch, zPitch, summation);

  return;
}