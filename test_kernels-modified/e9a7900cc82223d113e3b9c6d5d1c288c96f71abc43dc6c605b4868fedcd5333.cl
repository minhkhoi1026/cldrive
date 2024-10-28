//{"centerAndRadius":2,"deletionBuffer":1,"positions":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DeletionSphere(global float4* positions, global int* deletionBuffer, float4 centerAndRadius) {
  const int idx = get_global_id(0);
  float3 position = positions[hook(0, idx)].xyz;
  float3 center = centerAndRadius.xyz;
  float radiusSqr = centerAndRadius.w * centerAndRadius.w;
  float3 p = position - center;
  if (dot(p, p) > radiusSqr)
    deletionBuffer[hook(1, idx)] = 1;
}