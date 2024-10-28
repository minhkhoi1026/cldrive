//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void amdDeinterleaveFFTBlock(global const float* in, global float* out) {
  int glbl_id = get_global_id(0);

  out[hook(1, glbl_id)] = in[hook(0, glbl_id * 2)];
}