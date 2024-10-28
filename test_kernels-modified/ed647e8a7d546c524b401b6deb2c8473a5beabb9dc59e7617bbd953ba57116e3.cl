//{"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kern(global float* out) {
  size_t i = get_global_id(0);
  out[hook(0, i)] = i;
}