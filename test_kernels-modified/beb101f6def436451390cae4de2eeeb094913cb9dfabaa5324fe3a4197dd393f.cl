//{"damageSurface":0,"localBuffer":3,"points":1,"results":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t damageSurfaceSampler = 1 | 2 | 0x20;
kernel void DamageSurfaceSample(read_only image2d_t damageSurface, global float2* points, global float* results, local float4* localBuffer) {
  int tid = get_global_id(0);
  float2 point = points[hook(1, tid)];
  float2 normalized = (float2)(642.2889f / point.x, 192.5287f / point.y);
  float4 dSurfValue = read_imagef(damageSurface, damageSurfaceSampler, normalized);

  results[hook(2, tid)] = dSurfValue.w;
}