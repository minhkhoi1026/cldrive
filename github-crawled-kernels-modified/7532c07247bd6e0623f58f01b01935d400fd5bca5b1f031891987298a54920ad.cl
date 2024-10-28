//{"degreeBuffer":3,"forceBuffer":6,"inverseMassBuffer":2,"maxDegree":0,"pairBuffer":4,"pairParamBuffer":5,"positionBuffer":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float4 gravity = (float4)(0, 0, -10, 0);
kernel void calcForces(int maxDegree, global float4* positionBuffer, global float* inverseMassBuffer, global int* degreeBuffer, global int* pairBuffer, global float2* pairParamBuffer, global float4* forceBuffer) {
  int point = get_global_id(0);
  int first = point * maxDegree;

  float invMass = inverseMassBuffer[hook(2, point)];
  if (invMass > 1e-5f) {
    forceBuffer[hook(6, point)] = gravity / invMass;
  }
  for (int i = 0; i < degreeBuffer[hook(3, point)]; ++i) {
    int other = pairBuffer[hook(4, first + i)];

    float dist = distance(positionBuffer[hook(1, other)], positionBuffer[hook(1, point)]);

    if (dist < 1e-5f)
      continue;

    float4 to_other = (positionBuffer[hook(1, other)] - positionBuffer[hook(1, point)]) / dist;

    forceBuffer[hook(6, point)] += to_other * pairParamBuffer[hook(5, first + i)].y * (dist - pairParamBuffer[hook(5, first + i)].x);
  }
}