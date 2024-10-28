//{"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fill(global int* out) {
  unsigned int id = get_global_id(0) + 4 * get_global_id(1) + 16 * get_global_id(2);
  out[hook(0, id)] = id;
}