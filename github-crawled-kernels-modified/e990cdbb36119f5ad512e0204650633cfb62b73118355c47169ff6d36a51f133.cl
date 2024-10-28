//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void run_sin(global float* in, global float* out) {
  int idx = get_global_id(0);
  out[hook(1, idx)] = sin(sin((in[hook(0, idx)])));
}