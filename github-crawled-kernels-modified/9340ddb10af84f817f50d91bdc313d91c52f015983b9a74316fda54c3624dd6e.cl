//{"N":0,"in":1,"inoffset":2,"out":3,"outoffset":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy_with_offset(const int N, global const float* in, const int inoffset, global float* out, const int outoffset) {
  const int globalId = get_global_id(0);
  if (globalId >= N) {
    return;
  }
  out[hook(3, globalId + outoffset)] = in[hook(1, globalId + inoffset)];
}