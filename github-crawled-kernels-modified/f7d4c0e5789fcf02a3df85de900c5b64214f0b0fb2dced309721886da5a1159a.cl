//{"N":0,"batch":3,"dx":2,"filters":4,"input":6,"output":7,"spatial":5,"x":1}
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
    int val = input[hook(6, i * stride)];
    largest = (val > largest) ? val : largest;
  }
  for (i = 0; i < n; ++i) {
    float e = exp(input[hook(6, i * stride)] / temp - largest / temp);
    sum += e;
    output[hook(7, i * stride)] = e;
  }
  for (i = 0; i < n; ++i) {
    output[hook(7, i * stride)] /= sum;
  }
}
kernel void l2norm_kernel(int N, global float* x, global float* dx, int batch, int filters, int spatial) {
  int index = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (index >= N)
    return;
  int b = index / spatial;
  int i = index % spatial;
  int f;
  float sum = 0;
  for (f = 0; f < filters; ++f) {
    int index = b * filters * spatial + f * spatial + i;
    sum += pow(x[hook(1, index)], 2);
  }
  sum = sqrt(sum);
  if (sum == 0)
    sum = 1;
  for (f = 0; f < filters; ++f) {
    int index = b * filters * spatial + f * spatial + i;
    x[hook(1, index)] /= sum;
    dx[hook(2, index)] = (1 - x[hook(1, index)]) / sum;
  }
}