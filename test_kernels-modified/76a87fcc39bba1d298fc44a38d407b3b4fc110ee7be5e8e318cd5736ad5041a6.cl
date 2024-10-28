//{"numPoints":3,"pointAcceleration":1,"pointMass":2,"pointPosition":0,"repulsion":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
union BufferType {
  float f;
  unsigned int u;
};

kernel void applyCoulombsLaw(global float4* pointPosition, global float4* pointAcceleration, global float* pointMass, const int numPoints, const float repulsion) {
  const int p1 = get_global_id(0);
  if (p1 >= numPoints)
    return;

  float4 pointPositionP1 = pointPosition[hook(0, p1)];
  float pointMassP1 = pointMass[hook(2, p1)];
  float4 accelerationSum = 0;
  for (int p2 = 0; p2 < numPoints; p2++) {
    if (p1 == p2)
      continue;

    float4 direction = pointPositionP1 - pointPosition[hook(0, p2)];
    float distance = length(direction);
    direction *= (float)1 / fmax(distance, (float)0.1f);

    float f = repulsion / fmax(distance * distance * (float)0.5f, (float)0.005f);
    float4 force = direction * f;
    accelerationSum += force * ((float)1 / pointMassP1);
  }
  pointAcceleration[hook(1, p1)] += accelerationSum;
}