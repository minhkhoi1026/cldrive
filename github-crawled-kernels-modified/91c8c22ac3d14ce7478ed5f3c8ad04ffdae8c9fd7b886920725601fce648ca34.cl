//{"nodeCenterOfGravity":8,"nodeEntries":5,"nodeHalf":6,"nodeMass":7,"nodeState":4,"pointAcceleration":1,"pointMass":2,"pointPosition":0,"repulsion":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct tree_global {
  volatile int nextNode;
  volatile int activeNodes;
  int depth;
  int pad;
};

kernel void applyCoulombsLawBarnesHut(global float4* pointPosition, global float4* pointAcceleration, global float* pointMass, const float repulsion, global unsigned int* nodeState, global int* nodeEntries, global float4* nodeHalf, global float* nodeMass, global float4* nodeCenterOfGravity) {
  const int p1 = get_global_id(0);

  float4 pointPositionP1 = pointPosition[hook(0, p1)];
  float pointMassP1 = pointMass[hook(2, p1)];
  float4 accelerationSum = 0;

  pointAcceleration[hook(1, p1)] += accelerationSum;
}