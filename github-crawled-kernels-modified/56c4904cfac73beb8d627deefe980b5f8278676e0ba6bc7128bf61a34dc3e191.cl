//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void atomic_race_before(global int* data) {
  if (get_global_id(0) == 0) {
    *data = 0;
  }
  atomic_dec(data);
}