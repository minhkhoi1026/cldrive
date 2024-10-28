//{"pred":0,"prefSum":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compact_exscan(global int* pred, global int* prefSum) {
  int id = get_global_id(0);
  prefSum[hook(1, id)] = (id > 0) ? pred[hook(0, id - 1)] : 0;
  barrier(0x02);

  for (int s = 1; s < get_global_size(0); s *= 2) {
    int tmp = prefSum[hook(1, id)];
    if (id + s < get_global_size(0)) {
      prefSum[hook(1, id + s)] += tmp;
    }
    barrier(0x02);
  }
  if (id == 0) {
    prefSum[hook(1, 0)] = 0;
  }
}