//{"N":0,"batch":4,"filters":5,"mean":2,"spatial":6,"variance":3,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void normalize_kernel(int N, global float* x, global float* mean, global float* variance, int batch, int filters, int spatial) {
  int index = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (index >= N)
    return;
  int f = (index / spatial) % filters;
  x[hook(1, index)] = (x[hook(1, index)] - mean[hook(2, f)]) / (sqrt(variance[hook(3, f)] + .00001f));
}