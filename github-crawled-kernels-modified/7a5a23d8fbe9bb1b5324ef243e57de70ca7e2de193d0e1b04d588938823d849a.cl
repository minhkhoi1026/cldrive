//{"N":0,"batch":5,"c":4,"forward":7,"h":3,"out":8,"stride":6,"w":2,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reorg_kernel(int N, global float* x, int w, int h, int c, int batch, int stride, int forward, global float* out) {
  int i = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (i >= N)
    return;
  int in_index = i;
  int in_w = i % w;
  i = i / w;
  int in_h = i % h;
  i = i / h;
  int in_c = i % c;
  i = i / c;
  int b = i % batch;
  int out_c = c / (stride * stride);
  int c2 = in_c % out_c;
  int offset = in_c / out_c;
  int w2 = in_w * stride + offset % stride;
  int h2 = in_h * stride + offset / stride;
  int out_index = w2 + w * stride * (h2 + h * stride * (c2 + out_c * b));
  if (forward)
    out[hook(8, out_index)] = x[hook(1, in_index)];
  else
    out[hook(8, in_index)] = x[hook(1, out_index)];
}