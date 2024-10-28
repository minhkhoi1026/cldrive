//{"counters":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void atomic_out_of_bounds(global int* counters) {
  int i = get_global_id(0);
  atomic_inc(counters + i);
}