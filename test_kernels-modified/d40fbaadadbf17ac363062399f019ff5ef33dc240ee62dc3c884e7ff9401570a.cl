//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void exscan_global(global int* data) {
  int id = get_global_id(0);
  data[hook(0, id)] = (id > 0) ? data[hook(0, id - 1)] : 0;
  barrier(0x02);

  for (int s = 1; s < get_global_size(0); s *= 2) {
    int tmp = data[hook(0, id)];
    if (id + s < get_global_size(0)) {
      data[hook(0, id + s)] += tmp;
    }
    barrier(0x02);
  }
  if (id == 0) {
    data[hook(0, 0)] = 0;
  }
}