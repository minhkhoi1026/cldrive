//{"deletionBuffer":1,"positions":0,"threshold":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DeletionDensityThreshold(global float4* positions, global int* deletionBuffer, float threshold) {
  const int idx = get_global_id(0);
  if (positions[hook(0, idx)].w < threshold)
    deletionBuffer[hook(1, idx)] = 1;
}