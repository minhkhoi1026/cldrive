//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void displayGrid(global float* in, global float* out) {
  size_t tid = get_global_id(0);
  out[hook(1, tid)] = in[hook(0, tid)];
}