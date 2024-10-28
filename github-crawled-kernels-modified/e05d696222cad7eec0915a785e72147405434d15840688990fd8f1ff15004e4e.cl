//{"in":0,"out":1,"reduce_factor":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void max_float(global float* in, global float* out, unsigned int reduce_factor) {
  int x = get_global_id(0);
  int size0 = get_global_size(0);
  unsigned int begin = x;
  int i = 1;
  float tmp, max_val = in[hook(0, begin)];
  do {
    begin += size0;
    tmp = in[hook(0, begin)];
    max_val = tmp < max_val ? max_val : tmp;
    i++;
  } while (i != reduce_factor);
  out[hook(1, x)] = max_val;
}