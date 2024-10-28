//{"output":0,"scratch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void uninitialized_local_array(global float* output) {
  local float scratch[16];

  int i = get_local_id(0);
  if (i != get_local_size(0) / 2) {
    scratch[hook(1, i)] = i;
  }
  output[hook(0, i)] = scratch[hook(1, i)];
}