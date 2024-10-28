//{"batch":4,"delta":1,"filters":5,"mean":2,"part":8,"spatial":6,"variance":3,"variance_delta":7,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fast_variance_delta_kernel(global float* x, global float* delta, global float* mean, global float* variance, int batch, int filters, int spatial, global float* variance_delta) {
  local float part[512];
  int id = get_global_id(1);
  int filter = get_global_id(0);
  float sum = 0;
  int i, j;
  for (j = 0; j < batch; ++j) {
    for (i = 0; i < spatial; i += 512) {
      int index = j * spatial * filters + filter * spatial + i + id;
      sum += (i + id < spatial) ? delta[hook(1, index)] * (x[hook(0, index)] - mean[hook(2, filter)]) : 0;
    }
  }
  part[hook(8, id)] = sum;
  barrier(0x01);
  if (id == 0) {
    variance_delta[hook(7, filter)] = 0;
    for (i = 0; i < 512; ++i) {
      variance_delta[hook(7, filter)] += part[hook(8, i)];
    }
    variance_delta[hook(7, filter)] *= -.5f * pow(variance[hook(3, filter)] + .00001f, (float)(-3.f / 2.f));
  }
}