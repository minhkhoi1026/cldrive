//{"coefx":2,"coefy":3,"coefz":4,"dimx":5,"dimy":6,"dimz":7,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_hicl_5(global float4* input, global float4* output, constant float* coefx, constant float* coefy, constant float* coefz, int dimx, int dimy, int dimz) {
  int gid = get_global_id(0);
}