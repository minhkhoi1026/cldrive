//{"batch":1,"filters":2,"mean":4,"spatial":3,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mean_kernel(global float* x, int batch, int filters, int spatial, global float* mean) {
  float scale = 1.f / (batch * spatial);
  int i = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (i >= filters)
    return;
  int j, k;
  mean[hook(4, i)] = 0;
  for (j = 0; j < batch; ++j) {
    for (k = 0; k < spatial; ++k) {
      int index = j * filters * spatial + i * spatial + k;
      mean[hook(4, i)] += x[hook(0, index)];
    }
  }
  mean[hook(4, i)] *= scale;
}