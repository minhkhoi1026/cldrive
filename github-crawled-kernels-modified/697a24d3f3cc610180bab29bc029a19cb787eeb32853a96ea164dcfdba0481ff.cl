//{"dimx":2,"dimy":3,"dimz":4,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_hicl_6(global float4* input, global float4* output, int dimx, int dimy, int dimz) {
  int gid = get_global_id(0);
}