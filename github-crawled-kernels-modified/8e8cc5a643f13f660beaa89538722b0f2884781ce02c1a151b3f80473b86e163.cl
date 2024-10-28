//{"dst":5,"img_size":1,"n":0,"scale":2,"x":3,"y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Axpy_float2(int n, int img_size, global const float* scale, global const float2* x, global const float2* y, global float2* dst) {
  int idx = get_global_id(0);
  int scale_id = idx / (img_size >> 1);

  if (idx < n) {
    dst[hook(5, idx)] = scale[hook(2, scale_id)] * x[hook(3, idx)] + y[hook(4, idx)];
  }
}