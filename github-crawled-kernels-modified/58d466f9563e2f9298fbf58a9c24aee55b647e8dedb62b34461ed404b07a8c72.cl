//{"batch":2,"batch_offset":3,"group_offset":5,"groups":4,"input":0,"n":1,"output":8,"stride":6,"temp":7}
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
    output[hook(8, i * stride)] = e;
  }
  for (i = 0; i < n; ++i) {
    output[hook(8, i * stride)] /= sum;
  }
}
kernel void softmax_kernel(global float* input, int n, int batch, int batch_offset, int groups, int group_offset, int stride, float temp, global float* output) {
  int id = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (id >= batch * groups)
    return;
  int b = id / groups;
  int g = id % groups;
  softmax_device(input + b * batch_offset + g * group_offset, n, temp, stride, output + b * batch_offset + g * group_offset);
}