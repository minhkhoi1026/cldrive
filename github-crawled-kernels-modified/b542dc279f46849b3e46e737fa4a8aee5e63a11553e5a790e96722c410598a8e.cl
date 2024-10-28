//{"batch":2,"delta":0,"filters":3,"mean_delta":5,"spatial":4,"variance":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mean_delta_kernel(global float* delta, global float* variance, int batch, int filters, int spatial, global float* mean_delta) {
  int i = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (i >= filters)
    return;
  int j, k;
  mean_delta[hook(5, i)] = 0;
  for (j = 0; j < batch; ++j) {
    for (k = 0; k < spatial; ++k) {
      int index = j * filters * spatial + i * spatial + k;
      mean_delta[hook(5, i)] += delta[hook(0, index)];
    }
  }
  mean_delta[hook(5, i)] *= (-1.f / sqrt(variance[hook(1, i)] + .00001f));
}