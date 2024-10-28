//{"data":0,"gaus":1,"out":4,"sobx":2,"soby":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void initialized(global unsigned char* data, global float* gaus, global int* sobx, global int* soby, global unsigned char* out) {
  out[hook(4, 0)] = 0;
}