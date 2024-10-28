//{"a":0,"b":1,"len":3,"scale":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void STREAM_Scale(global double* a, global double* b, global double* scale, global int* len) {
  int threadIdX = get_local_id(0);
  int workGroupSize = get_global_size(0);
  int idx = get_global_id(0);

  if (idx < *len)
    b[hook(1, idx)] = (*scale) * a[hook(0, idx)];
}