//{"c":3,"h":2,"in_delta":4,"n":0,"out_delta":5,"w":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void backward_avgpool_layer_kernel(int n, int w, int h, int c, global float* in_delta, global float* out_delta) {
  int id = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (id >= n)
    return;

  int k = id % c;
  id /= c;
  int b = id;

  int i;
  int out_index = (k + c * b);
  for (i = 0; i < w * h; ++i) {
    int in_index = i + h * w * (k + b * c);
    in_delta[hook(4, in_index)] += out_delta[hook(5, out_index)] / (w * h);
  }
}