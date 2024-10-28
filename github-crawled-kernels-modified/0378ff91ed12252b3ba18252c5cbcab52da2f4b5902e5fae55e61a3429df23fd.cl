//{"batch":1,"filters":2,"mean":4,"part":5,"spatial":3,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fast_mean_kernel(global float* x, int batch, int filters, int spatial, global float* mean) {
  local float part[512];
  int id = get_global_id(1);
  int filter = get_global_id(0);
  float sum = 0;
  int i, j;
  for (j = 0; j < batch; ++j) {
    for (i = 0; i < spatial; i += 512) {
      int index = j * spatial * filters + filter * spatial + i + id;
      sum += (i + id < spatial) ? x[hook(0, index)] : 0;
    }
  }
  part[hook(5, id)] = sum;
  barrier(0x01);
  if (id == 0) {
    mean[hook(4, filter)] = 0;
    for (i = 0; i < 512; ++i) {
      mean[hook(4, filter)] += part[hook(5, i)];
    }
    mean[hook(4, filter)] /= spatial * batch;
  }
}