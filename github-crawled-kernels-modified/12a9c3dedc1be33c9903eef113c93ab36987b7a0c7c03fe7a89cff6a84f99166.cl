//{"N":0,"batch":6,"delta":9,"filters":7,"mean":2,"mean_delta":4,"spatial":8,"variance":3,"variance_delta":5,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void normalize_delta_kernel(int N, global float* x, global float* mean, global float* variance, global float* mean_delta, global float* variance_delta, int batch, int filters, int spatial, global float* delta) {
  int index = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (index >= N)
    return;
  int f = (index / spatial) % filters;
  delta[hook(9, index)] = delta[hook(9, index)] * 1.f / (sqrt(variance[hook(3, f)] + .00001f)) + variance_delta[hook(5, f)] * 2.f * (x[hook(1, index)] - mean[hook(2, f)]) / (spatial * batch) + mean_delta[hook(4, f)] / (spatial * batch);
}