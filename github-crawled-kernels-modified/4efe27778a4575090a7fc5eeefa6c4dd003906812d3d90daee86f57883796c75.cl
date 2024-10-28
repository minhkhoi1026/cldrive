//{"batch":2,"filters":3,"mean":1,"spatial":4,"variance":5,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void variance_kernel(global float* x, global float* mean, int batch, int filters, int spatial, global float* variance) {
  float scale = 1.f / (batch * spatial - 1);
  int j, k;
  int i = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (i >= filters)
    return;
  variance[hook(5, i)] = 0;
  for (j = 0; j < batch; ++j) {
    for (k = 0; k < spatial; ++k) {
      int index = j * filters * spatial + i * spatial + k;
      variance[hook(5, i)] += pow((x[hook(0, index)] - mean[hook(1, i)]), 2);
    }
  }
  variance[hook(5, i)] *= scale;
}