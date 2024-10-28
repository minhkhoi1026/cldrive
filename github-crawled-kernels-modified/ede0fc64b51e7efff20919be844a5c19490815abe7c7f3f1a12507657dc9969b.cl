//{"input":5,"mask":3,"mask_num":2,"n":0,"output":6,"scale":4,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void softmax_device(global float* input, int n, float temp, int stride, global float* output) {
  int i;
  float sum = 0;
  float largest = -(__builtin_inff());
  for (i = 0; i < n; ++i) {
    int val = input[hook(5, i * stride)];
    largest = (val > largest) ? val : largest;
  }
  for (i = 0; i < n; ++i) {
    float e = exp(input[hook(5, i * stride)] / temp - largest / temp);
    sum += e;
    output[hook(6, i * stride)] = e;
  }
  for (i = 0; i < n; ++i) {
    output[hook(6, i * stride)] /= sum;
  }
}
kernel void scale_mask_kernel(int n, global float* x, float mask_num, global float* mask, float scale) {
  int i = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (i < n && mask[hook(3, i)] == mask_num)
    x[hook(1, i)] *= scale;
}