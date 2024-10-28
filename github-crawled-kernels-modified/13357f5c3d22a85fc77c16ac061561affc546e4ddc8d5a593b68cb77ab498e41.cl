//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void atomic_race_after(global int* data) {
  atomic_inc(data);
  if (get_global_id(0) == get_global_size(0) - 1) {
    (*data)++;
  }
}