//{"data":0,"pred":1,"prefSum":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compact_compact(global int* data, global int* pred, global int* prefSum) {
  int id = get_global_id(0);
  int val = data[hook(0, id)];
  barrier(0x02);
  if (pred[hook(1, id)] == 1) {
    data[hook(0, prefSum[ihook(2, id))] = val;
  }
}