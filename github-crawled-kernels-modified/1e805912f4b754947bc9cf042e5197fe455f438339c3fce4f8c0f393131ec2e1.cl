//{"numPoints":4,"pointAcceleration":0,"pointSpringAccelSlotCount":3,"pointSpringAccelSlotOffset":2,"pointSpringAcceleration":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
union BufferType {
  float f;
  unsigned int u;
};

kernel void sumPointSpringAccel(global float4* pointAcceleration, global float4* pointSpringAcceleration, global unsigned int* pointSpringAccelSlotOffset, global unsigned int* pointSpringAccelSlotCount, const int numPoints) {
  const int p = get_global_id(0);
  if (p >= numPoints)
    return;

  const unsigned int start = pointSpringAccelSlotOffset[hook(2, p)];
  const unsigned int end = start + pointSpringAccelSlotCount[hook(3, p)];

  float4 accelerationSum = (float)0;
  for (unsigned int accelslot = start; accelslot < end; accelslot++) {
    accelerationSum += pointSpringAcceleration[hook(1, accelslot)];
  }
  pointAcceleration[hook(0, p)] += accelerationSum;
}