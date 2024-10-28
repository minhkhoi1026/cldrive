//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void atomic_same_workitem(global int* data) {
  int i = get_global_id(0);
  if ((i % 2) == 0) {
    data[hook(0, i)] = 0;
    atomic_inc(data + i);
  } else {
    atomic_inc(data + i);
    data[hook(0, i)] = data[hook(0, i)] + 1;
  }
}