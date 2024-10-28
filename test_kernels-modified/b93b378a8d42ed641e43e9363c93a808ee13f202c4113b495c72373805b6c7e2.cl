//{"mcgrid":1,"numVolIdx":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mc_kernel_reset(int numVolIdx, global float4* mcgrid) {
  size_t gid = get_global_id(0);

  mcgrid[hook(1, gid)].w = 0.0;
}