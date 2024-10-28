//{"dstAccumulator":1,"srcAccumulator":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void aggregateAccumulator(global float3* srcAccumulator, global float3* dstAccumulator) {
  int globalId = get_global_id(0);
  dstAccumulator[hook(1, globalId)] += srcAccumulator[hook(0, globalId)];
}