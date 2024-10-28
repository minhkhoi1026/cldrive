//{"in":0,"out":1,"reduce_factor":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void max_atomic(global int* in, global int* out, unsigned int reduce_factor) {
  int id0 = get_global_id(0);
  int size0 = get_global_size(0);
  unsigned index = id0;
  int i = 1, max_val;
  max_val = in[hook(0, index)];
  index += size0;
  for (; i != reduce_factor; i++) {
    max_val = max_val < in[hook(0, index)] ? in[hook(0, index)] : max_val;
    index += size0;
  }
  atomic_max(out, max_val);
}