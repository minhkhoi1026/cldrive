//{"dst":5,"img_size":1,"n":0,"scale":2,"x":3,"y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Axpy_float4(int n, int img_size, global const float* scale, global const float4* x, global const float4* y, global float4* dst) {
  int idx = get_global_id(0);
  int scale_id = idx / (img_size >> 2);

  if (idx < n) {
    dst[hook(5, idx)] = scale[hook(2, scale_id)] * x[hook(3, idx)] + y[hook(4, idx)];
  }
}