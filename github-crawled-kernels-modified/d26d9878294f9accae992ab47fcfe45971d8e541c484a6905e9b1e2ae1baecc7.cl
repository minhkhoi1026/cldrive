//{"output":1,"scratch":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void uninitialized_local_ptr(local float* scratch, global float* output) {
  int i = get_local_id(0);
  if (i != get_local_size(0) / 2) {
    scratch[hook(0, i)] = i;
  }
  output[hook(1, i)] = scratch[hook(0, i)];
}