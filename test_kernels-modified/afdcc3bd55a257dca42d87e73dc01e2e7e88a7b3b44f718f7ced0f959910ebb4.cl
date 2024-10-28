//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce_global(global float* data) {
  int id = get_global_id(0);

  for (unsigned int s = get_global_size(0) / 2; s > 0; s >>= 1) {
    if (id < s) {
      data[hook(0, id)] = max(data[hook(0, id)], data[hook(0, id + s)]);
    }
    barrier(0x02);
  }
}