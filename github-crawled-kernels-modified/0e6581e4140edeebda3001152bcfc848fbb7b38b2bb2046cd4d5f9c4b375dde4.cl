//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void input_eq_output(global int* in, global int* out) {
  int globalID = get_global_id(0);
  out[hook(1, globalID)] = in[hook(0, globalID)];
}