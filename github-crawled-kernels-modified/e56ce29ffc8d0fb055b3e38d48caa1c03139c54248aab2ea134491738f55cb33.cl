//{"PARTICLE_COUNT":1,"neighborMap":0,"nm":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clearBuffers(global float2* neighborMap, unsigned int PARTICLE_COUNT) {
  int id = get_global_id(0);
  if (id >= PARTICLE_COUNT)
    return;
  global float4* nm = (global float4*)neighborMap;
  int outIdx = (id * 32) >> 1;
  float4 fdata = (float4)(-1.0f, -1.0f, -1.0f, -1.0f);
  int i, j, k, mnl;

  nm[hook(2, outIdx++)] = fdata;
  nm[hook(2, outIdx++)] = fdata;
  nm[hook(2, outIdx++)] = fdata;
  nm[hook(2, outIdx++)] = fdata;
  nm[hook(2, outIdx++)] = fdata;
  nm[hook(2, outIdx++)] = fdata;
  nm[hook(2, outIdx++)] = fdata;
  nm[hook(2, outIdx++)] = fdata;
  nm[hook(2, outIdx++)] = fdata;
  nm[hook(2, outIdx++)] = fdata;
  nm[hook(2, outIdx++)] = fdata;
  nm[hook(2, outIdx++)] = fdata;
  nm[hook(2, outIdx++)] = fdata;
  nm[hook(2, outIdx++)] = fdata;
  nm[hook(2, outIdx++)] = fdata;
  nm[hook(2, outIdx++)] = fdata;
}