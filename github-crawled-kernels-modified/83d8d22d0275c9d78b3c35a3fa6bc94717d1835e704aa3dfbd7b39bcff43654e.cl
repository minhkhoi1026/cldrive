//{"batch":2,"bias_updates":0,"delta":1,"n":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void backward_bias_conn_kernel(global float* bias_updates, global float* delta, int batch, int n) {
  int index = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (index >= n)
    return;
  int b;
  float sum = 0;
  for (b = 0; b < batch; ++b) {
    int i = b * n + index;
    sum += delta[hook(1, i)];
  }
  bias_updates[hook(0, index)] += sum;
}