//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void atomic_cmpxchg_write_race(global int* data) {
  int i = get_global_id(0);
  if (i == 0) {
    *data = 0;
  }
  atomic_cmpxchg(data, i, 42);
}