//{"count":0,"in":1,"out":2,"s":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void stencil(global size_t* count, global double* in, global double* out, global double* s) {
  int workGroupX = get_local_size(0);
  int workIdX = get_group_id(0);
  int threadIdX = get_local_id(0);
  int workGroupSize = get_global_size(0);
  int i;

  for (i = (workGroupX * workIdX + 1) + threadIdX; i < *count - 1; i += workGroupSize) {
    out[hook(2, i)] = s[hook(3, 0)] * in[hook(1, i - 1)] + s[hook(3, 1)] * in[hook(1, i)] + s[hook(3, 2)] * in[hook(1, i + 1)];
  }
}