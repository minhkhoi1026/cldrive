//{"log":0,"output":1,"storage":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef unsigned char(uchar);
kernel void log_lstat64(global uchar* log, local uchar* output, global uchar* storage) {
  uchar* input = log[hook(0, get_global_id(0))];
  output[hook(1, get_local_id(0))] = input;
  barrier(0x01);

  int i;
  uchar** store;

  if (get_local_id(0) == 0) {
    for (i = 0; i < get_local_size(0); i++) {
      store += output[hook(1, i)];
    }
    storage[hook(2, get_group_id(0))] += store;
  }
}