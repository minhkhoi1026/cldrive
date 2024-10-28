//{"batch":2,"delta":1,"n":3,"part":6,"scale_updates":5,"size":4,"x_norm":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void backward_scale_kernel(global float* x_norm, global float* delta, int batch, int n, int size, global float* scale_updates) {
  local float part[512];
  int i, b;
  int filter = get_global_id(0);
  int p = get_global_id(1);
  float sum = 0;
  for (b = 0; b < batch; ++b) {
    for (i = 0; i < size; i += 512) {
      int index = p + i + size * (filter + n * b);
      sum += (p + i < size) ? delta[hook(1, index)] * x_norm[hook(0, index)] : 0;
    }
  }
  part[hook(6, p)] = sum;
  barrier(0x01);
  if (p == 0) {
    for (i = 0; i < 512; ++i)
      scale_updates[hook(5, filter)] += part[hook(6, i)];
  }
}