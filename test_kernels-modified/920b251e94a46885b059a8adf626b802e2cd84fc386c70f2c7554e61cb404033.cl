//{"cellSize":1,"kEpsilon":4,"kNearNorm":3,"kNorm":2,"m":0,"mcgrid":6,"numVolIdx":7,"pos":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mc_kernel_gridval(float m, float cellSize, float kNorm, float kNearNorm, float kEpsilon, global float4* pos, global float4* mcgrid, int numVolIdx) {
  size_t gid = get_global_id(0);

  float3 myPos = pos[hook(5, gid)].xyz;

  int i;
  float3 posJ;

  float a;

  for (i = 0; i < numVolIdx; i++) {
    posJ = mcgrid[hook(6, i)].xyz;
    a = 0.0;

    float r = length(myPos - posJ);

    if (r >= kEpsilon && r <= cellSize) {
      a = cellSize / r;
    } else
      continue;

    mcgrid[hook(6, i)].w += m * a * kNearNorm;
  }
}