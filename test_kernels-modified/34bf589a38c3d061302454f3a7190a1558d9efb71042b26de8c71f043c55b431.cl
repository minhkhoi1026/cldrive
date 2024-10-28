//{"accumulator":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clearAccumulator(global float3* accumulator) {
  accumulator[hook(0, get_global_id(0))] = (float3)(0.0f, 0.0f, 0.0f);
}