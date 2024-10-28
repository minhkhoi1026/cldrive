//{"N":0,"batch":5,"c":4,"forward":7,"h":3,"input":10,"out":9,"output":11,"scale":8,"stride":6,"w":2,"x":1}
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
    int val = input[hook(10, i * stride)];
    largest = (val > largest) ? val : largest;
  }
  for (i = 0; i < n; ++i) {
    float e = exp(input[hook(10, i * stride)] / temp - largest / temp);
    sum += e;
    output[hook(11, i * stride)] = e;
  }
  for (i = 0; i < n; ++i) {
    output[hook(11, i * stride)] /= sum;
  }
}
void atomic_float_add(volatile global float* addr, float v) {
  volatile global int* p = (volatile global int*)addr;
  int last_value;
  float result;
  do {
    last_value = *p;
    result = v + __builtin_astype((last_value), float);
  } while (atomic_cmpxchg(p, last_value, __builtin_astype((result), int)) != last_value);
}
kernel void upsample_kernel(int N, global float* x, int w, int h, int c, int batch, int stride, int forward, float scale, global float* out) {
  int i = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (i >= N)
    return;
  int out_index = i;
  int out_w = i % (w * stride);
  i = i / (w * stride);
  int out_h = i % (h * stride);
  i = i / (h * stride);
  int out_c = i % c;
  i = i / c;
  int b = i % batch;
  int in_w = out_w / stride;
  int in_h = out_h / stride;
  int in_c = out_c;
  int in_index = b * w * h * c + in_c * w * h + in_h * w + in_w;
  if (forward)
    out[hook(9, out_index)] += scale * x[hook(1, in_index)];
  else
    atomic_float_add(x + in_index, scale * out[hook(9, out_index)]);
}