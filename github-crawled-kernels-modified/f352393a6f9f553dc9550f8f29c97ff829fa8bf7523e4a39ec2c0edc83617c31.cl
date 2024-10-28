//{"c":3,"h":2,"input":4,"n":0,"output":5,"w":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void forward_avgpool_layer_kernel(int n, int w, int h, int c, global float* input, global float* output) {
  int id = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (id >= n)
    return;

  int k = id % c;
  id /= c;
  int b = id;

  int i;
  int out_index = (k + c * b);
  output[hook(5, out_index)] = 0;
  for (i = 0; i < w * h; ++i) {
    int in_index = i + h * w * (k + b * c);
    output[hook(5, out_index)] += input[hook(4, in_index)];
  }
  output[hook(5, out_index)] /= w * h;
}