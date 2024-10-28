//{"deletionBuffer":1,"maxBox":3,"minBox":2,"positions":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DeletionBox(global float4* positions, global int* deletionBuffer, float4 minBox, float4 maxBox) {
  const int idx = get_global_id(0);
  float3 position = positions[hook(0, idx)].xyz;
  if (any(isless(position, minBox.xyz)) || any(isgreater(position, maxBox.xyz)))
    deletionBuffer[hook(1, idx)] = 1;
}