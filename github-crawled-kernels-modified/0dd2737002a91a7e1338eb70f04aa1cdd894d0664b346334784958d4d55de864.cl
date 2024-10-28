//{"in":0,"out":1,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void complex_to_real(global float2* in, global float* out, unsigned int size) {
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0)) {
    out[hook(1, i)] = in[hook(0, i)].x;
  }
}