//{"batch":2,"filters":3,"mean":1,"part":6,"spatial":4,"variance":5,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fast_variance_kernel(global float* x, global float* mean, int batch, int filters, int spatial, global float* variance) {
  local float part[512];
  int id = get_global_id(1);
  int filter = get_global_id(0);
  float sum = 0;
  int i, j;
  for (j = 0; j < batch; ++j) {
    for (i = 0; i < spatial; i += 512) {
      int index = j * spatial * filters + filter * spatial + i + id;

      sum += (i + id < spatial) ? pow((x[hook(0, index)] - mean[hook(1, filter)]), 2) : 0;
    }
  }
  part[hook(6, id)] = sum;
  barrier(0x01);
  if (id == 0) {
    variance[hook(5, filter)] = 0;
    for (i = 0; i < 512; ++i) {
      variance[hook(5, filter)] += part[hook(6, i)];
    }
    variance[hook(5, filter)] /= (spatial * batch - 1);
  }
}