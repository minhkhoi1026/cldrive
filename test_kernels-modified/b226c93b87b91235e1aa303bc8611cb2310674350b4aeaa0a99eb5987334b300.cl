//{"numSprings":10,"pointAcceleration":1,"pointMass":3,"pointPosition":0,"pointSpringAcceleration":2,"springAccelSlotPoint1":8,"springAccelSlotPoint2":9,"springLength":4,"springPointIndex1":6,"springPointIndex2":7,"springStiffness":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
union BufferType {
  float f;
  unsigned int u;
};

kernel void applyHookesLaw(global float4* pointPosition, global float4* pointAcceleration, global float4* pointSpringAcceleration, global float* pointMass, global float* springLength, global float* springStiffness, global unsigned int* springPointIndex1, global unsigned int* springPointIndex2, global unsigned int* springAccelSlotPoint1, global unsigned int* springAccelSlotPoint2, const int numSprings) {
  const int s = get_global_id(0);
  if (s >= numSprings)
    return;
  const int p1 = springPointIndex1[hook(6, s)];
  const int p2 = springPointIndex2[hook(7, s)];

  float4 direction = pointPosition[hook(0, p2)] - pointPosition[hook(0, p1)];
  float distance = length(direction);
  float displacement = springLength[hook(4, s)] - distance;
  direction *= (float)1 / fmax(distance, (float)0.1f);

  float f = springStiffness[hook(5, s)] * displacement * (float)0.5f;
  float4 force1 = direction * -f;
  float4 force2 = direction * f;

  pointSpringAcceleration[hook(2, springAccelSlotPoint1[shook(8, s))] = force1 * ((float)1 / pointMass[hook(3, p1)]);
  pointSpringAcceleration[hook(2, springAccelSlotPoint2[shook(9, s))] = force2 * ((float)1 / pointMass[hook(3, p2)]);
}