//{"cols":4,"h":0,"out":2,"rows":3,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void array_mse_f32(global float* h, global float* y, global float* out, const ulong rows, const ulong cols) {
  ulong i = get_global_id(0);

  out[hook(2, i)] = 0.0;

  for (ulong m = 0; m < rows; m++) {
    float error = h[hook(0, m * cols + i)] - y[hook(1, m * cols + i)];
    out[hook(2, i)] += error * error;
  }

  out[hook(2, i)] /= (float)rows;
  out[hook(2, i)] /= 2.0;
}