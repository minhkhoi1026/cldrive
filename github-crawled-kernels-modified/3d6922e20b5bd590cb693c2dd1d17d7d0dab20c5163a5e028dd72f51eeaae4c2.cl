//{"batch":2,"group_offset":8,"group_size":7,"groups":6,"input":0,"output":5,"spatial":1,"stride":3,"temp":4}
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
    int val = input[hook(0, i * stride)];
    largest = (val > largest) ? val : largest;
  }
  for (i = 0; i < n; ++i) {
    float e = exp(input[hook(0, i * stride)] / temp - largest / temp);
    sum += e;
    output[hook(5, i * stride)] = e;
  }
  for (i = 0; i < n; ++i) {
    output[hook(5, i * stride)] /= sum;
  }
}
kernel void softmax_tree_kernel(global float* input, int spatial, int batch, int stride, float temp, global float* output, int groups, constant int* group_size, constant int* group_offset) {
  int id = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (id >= spatial * batch * groups)
    return;
  int s = id % spatial;
  id = id / spatial;
  int g = id % groups;
  int b = id / groups;
  int goff = group_offset[hook(8, g)] * spatial;
  int boff = b * stride;
  softmax_device(input + goff + boff + s, group_size[hook(7, g)], temp, spatial, output + goff + boff + s);
}