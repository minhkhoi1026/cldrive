//{"numPoints":5,"pointAcceleration":1,"pointGroupAcceleration":2,"pointMass":3,"pointPosition":0,"pointPositionLocal":4,"repulsion":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
union BufferType {
  float f;
  unsigned int u;
};

kernel void applyCoulombsLawGroup(global float4* pointPosition, global float4* pointAcceleration, global float4* pointGroupAcceleration, global float* pointMass, local float4* pointPositionLocal, const int numPoints, const float repulsion) {
  const int p1 = get_global_id(0);
  const int wg = get_global_id(1);
  const int numWorkItems = get_global_size(1);
  const int workGroupSize = get_local_size(0);
  const int lp2 = get_local_id(0);

  pointPositionLocal[hook(4, lp2)] = pointPosition[hook(0, wg * workGroupSize + lp2)];

  barrier(0x01);

  if (p1 >= numPoints)
    return;

  float4 pointPositionP1 = pointPosition[hook(0, p1)];
  float pointMassP1 = pointMass[hook(3, p1)];

  float4 accelerationSum = 0;
  const int p2offset = wg * workGroupSize;
  for (int wp2 = 0; wp2 < workGroupSize; wp2++) {
    const int p2 = p2offset + wp2;
    if (p1 == p2)
      continue;
    if (p2 >= numPoints)
      break;

    float4 direction = pointPositionP1 - pointPositionLocal[hook(4, wp2)];
    float distance = length(direction);
    direction *= (float)1 / fmax(distance, (float)0.1f);

    float f = repulsion / fmax(distance * distance * (float)0.5f, (float)0.005f);
    float4 force = direction * f;
    accelerationSum += force * ((float)1 / pointMassP1);
  }

  pointGroupAcceleration[hook(2, p1 * numWorkItems + wg)] += accelerationSum;
}