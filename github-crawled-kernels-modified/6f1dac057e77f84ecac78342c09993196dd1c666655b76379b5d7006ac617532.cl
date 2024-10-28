//{"array":15,"inputPoints":0,"inputvalues":14,"maxZ":5,"numPoints":6,"originX":11,"originY":12,"originZ":13,"outputBuffer":2,"outputPoint":1,"reconDimX":3,"reconDimY":4,"sigma":7,"voxelSpacingX":8,"voxelSpacingY":9,"voxelSpacingZ":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 getPointFromArray(global float* inputvalues, int i) {
  unsigned long idx = i;
  float4 voxel = (float4){inputvalues[hook(14, idx * 3)], inputvalues[hook(14, (idx * 3) + 1)], inputvalues[hook(14, (idx * 3) + 2)], 0};
  return voxel;
}

float4 getPointFromSearchArray(global const float* inputvalues, int i) {
  unsigned long idx = i;
  float4 voxel = (float4){inputvalues[hook(14, idx * 5)], inputvalues[hook(14, (idx * 5) + 1)], inputvalues[hook(14, (idx * 5) + 2)], 0};
  return voxel;
}

void setPointToArray(global float* array, int x, int y, int z, unsigned int yPitch, unsigned int zPitch, float4 vector) {
  unsigned long idx = z * zPitch + y * yPitch + x;
  array[hook(15, idx * 3)] = vector.x;
  array[hook(15, idx * 3 + 1)] = vector.y;
  array[hook(15, idx * 3 + 2)] = vector.z;
}

kernel void evaluateNN(global const float* inputPoints, global const float* outputPoint, global float* outputBuffer, int reconDimX, int reconDimY, int maxZ, int numPoints, float sigma, float voxelSpacingX, float voxelSpacingY, float voxelSpacingZ, float originX, float originY, float originZ) {
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
  float4 initial = (float4){xcoord, ycoord, zcoord, 0};

  float minDist = 100000;
  int minInd = -1;
  for (int i = 0; i < numPoints; i++) {
    float4 from = getPointFromArray(inputPoints, i);
    float dist = distance(from, initial);
    if (dist < minDist) {
      minDist = dist;
      minInd = i;
    }
  }
  float4 direction = (float4){0, 0, 0, 0};
  if (minInd != -1) {
    float4 from = getPointFromArray(inputPoints, minInd);
    float4 to = getPointFromArray(outputPoint, minInd);
    direction = to - from;
  }
  setPointToArray(outputBuffer, x, y, z, yPitch, zPitch, direction);
  return;
}