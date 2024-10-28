//{"batch":2,"bias_updates":0,"delta":1,"n":3,"part":5,"size":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void backward_bias_kernel(global float* bias_updates, global float* delta, int batch, int n, int size) {
  local float part[512];
  int i, b;
  int filter = get_global_id(0);
  int p = get_global_id(1);
  float sum = 0;
  for (b = 0; b < batch; ++b) {
    for (i = 0; i < size; i += 512) {
      int index = p + i + size * (filter + n * b);
      sum += (p + i < size) ? delta[hook(1, index)] : 0;
    }
  }
  part[hook(5, p)] = sum;
  barrier(0x01);
  if (p == 0) {
    for (i = 0; i < 512; ++i)
      bias_updates[hook(0, filter)] += part[hook(5, i)];
  }
}