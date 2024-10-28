//{"data":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void atomic_race_after(global int* data, global int* output) {
  atomic_inc(data);
  if (get_global_id(0) == get_global_size(0) - 1) {
    *output = *data;
  }
}