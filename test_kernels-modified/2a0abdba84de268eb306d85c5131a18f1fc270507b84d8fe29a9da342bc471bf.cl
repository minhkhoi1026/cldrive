//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int ave(int a, int b) {
  return (a + b) / 2;
}

kernel void simple(global int* data) {
  int tid = get_global_id(0) * get_global_size(0) + get_local_id(0);
  data[hook(0, tid)] = ave(tid, tid);
}