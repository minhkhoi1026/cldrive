//{"numPoints":2,"numWorkItems":3,"pointAcceleration":0,"pointGroupAcceleration":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
union BufferType {
  float f;
  unsigned int u;
};

kernel void sumPointGroupAccel(global float4* pointAcceleration, global float4* pointGroupAcceleration, const int numPoints, const int numWorkItems) {
  const int p = get_global_id(0);
  if (p >= numPoints)
    return;

  float4 accelerationSum = (float)0;
  for (int accelslot = 0; accelslot < numWorkItems; accelslot++) {
    accelerationSum += pointGroupAcceleration[hook(1, p * numWorkItems + accelslot)];
  }
  pointAcceleration[hook(0, p)] += accelerationSum;
}