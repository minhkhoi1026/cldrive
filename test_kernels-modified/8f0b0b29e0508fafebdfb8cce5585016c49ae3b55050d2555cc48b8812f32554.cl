//{"a":0,"b":1,"c":2,"len":4,"scale":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void STREAM_Triad(global double* a, global double* b, global double* c, global double* scale, global int* len) {
  int threadIdX = get_local_id(0);
  int workGroupSize = get_global_size(0);
  int idx = get_global_id(0);

  if (idx < *len)
    a[hook(0, idx)] = c[hook(2, idx)] * (*scale) + b[hook(1, idx)];
}