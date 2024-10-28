//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void csquares(global float* out, global float* in) {
  int i = get_global_id(0);
  out[hook(0, i)] = in[hook(1, i)] * in[hook(1, i)];
}