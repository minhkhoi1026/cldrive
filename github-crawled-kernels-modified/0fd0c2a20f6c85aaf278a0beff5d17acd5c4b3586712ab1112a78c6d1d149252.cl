//{"N":0,"batch":4,"forward":5,"layers":3,"out":6,"spatial":2,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void flatten_kernel(int N, global float* x, int spatial, int layers, int batch, int forward, global float* out) {
  int i = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (i >= N)
    return;
  int in_s = i % spatial;
  i = i / spatial;
  int in_c = i % layers;
  i = i / layers;
  int b = i;
  int i1 = b * layers * spatial + in_c * spatial + in_s;
  int i2 = b * layers * spatial + in_s * layers + in_c;
  if (forward)
    out[hook(6, i2)] = x[hook(1, i1)];
  else
    out[hook(6, i1)] = x[hook(1, i2)];
}