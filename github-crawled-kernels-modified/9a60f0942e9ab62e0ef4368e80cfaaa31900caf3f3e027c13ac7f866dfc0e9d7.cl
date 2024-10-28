//{"batch":2,"delta":0,"filters":3,"mean_delta":5,"part":6,"spatial":4,"variance":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fast_mean_delta_kernel(global float* delta, global float* variance, int batch, int filters, int spatial, global float* mean_delta) {
  local float part[512];
  int id = get_global_id(1);
  int filter = get_global_id(0);
  float sum = 0;
  int i, j;
  for (j = 0; j < batch; ++j) {
    for (i = 0; i < spatial; i += 512) {
      int index = j * spatial * filters + filter * spatial + i + id;
      sum += (i + id < spatial) ? delta[hook(0, index)] : 0;
    }
  }
  part[hook(6, id)] = sum;
  barrier(0x01);
  if (id == 0) {
    mean_delta[hook(5, filter)] = 0;
    for (i = 0; i < 512; ++i) {
      mean_delta[hook(5, filter)] += part[hook(6, i)];
    }
    mean_delta[hook(5, filter)] *= (-1.f / sqrt(variance[hook(1, filter)] + .00001f));
  }
}