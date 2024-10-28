//{"array":7,"bufferLength":3,"inputPoints":0,"inputvalues":6,"numPointsPerWorker":4,"outputBuffer":2,"outputPoint":1,"sigma":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 getPointFromArray(global float* inputvalues, int i) {
  unsigned long idx = i;
  float4 voxel = (float4){inputvalues[hook(6, idx * 3)], inputvalues[hook(6, (idx * 3) + 1)], inputvalues[hook(6, (idx * 3) + 2)], 0};
  return voxel;
}

float4 getPointFromSearchArray(global const float* inputvalues, int i) {
  unsigned long idx = i;
  float4 voxel = (float4){inputvalues[hook(6, idx * 5)], inputvalues[hook(6, (idx * 5) + 1)], inputvalues[hook(6, (idx * 5) + 2)], 0};
  return voxel;
}

void setPointToArray(global float* array, int x, int y, int z, unsigned int yPitch, unsigned int zPitch, float4 vector) {
  unsigned long idx = z * zPitch + y * yPitch + x;
  array[hook(7, idx * 3)] = vector.x;
  array[hook(7, idx * 3 + 1)] = vector.y;
  array[hook(7, idx * 3 + 2)] = vector.z;
}

kernel void evaluateParzen1D(global const float* inputPoints, global const float* outputPoint, global float* outputBuffer, int bufferLength, int numPointsPerWorker, float sigma) {
  int gidx = get_group_id(0);
  int lidx = get_local_id(0);
  int locSizex = get_local_size(0);
  int gloSizex = get_global_size(0);
  unsigned int x = gidx * locSizex + lidx;

  if (x >= bufferLength)
    return;

  float4 summation = (float4){0, 0, 0, 0};
  float4 initial = getPointFromArray(outputBuffer, x);
  float weightsum = 0;
  float factor = -0.5f / (sigma * sigma);
  float acc = 70;

  for (int i = 0; i < numPointsPerWorker; i++) {
    float4 from = getPointFromArray(inputPoints, i);
    float4 to = getPointFromArray(outputPoint, i);
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
  outputBuffer[hook(2, x * 3)] = summation.x;
  outputBuffer[hook(2, x * 3 + 1)] = summation.y;
  outputBuffer[hook(2, x * 3 + 2)] = summation.z;
  return;
}