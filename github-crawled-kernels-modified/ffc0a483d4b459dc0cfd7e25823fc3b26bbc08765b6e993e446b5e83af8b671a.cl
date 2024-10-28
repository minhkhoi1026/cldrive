//{"delta":3,"error":4,"input":5,"n":0,"output":6,"pred":1,"truth":2}
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
kernel void logistic_x_ent_kernel(int n, global float* pred, global float* truth, global float* delta, global float* error) {
  int i = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (i < n) {
    float t = truth[hook(2, i)];
    float p = pred[hook(1, i)];
    error[hook(4, i)] = -t * log(p + .0000001) - (1 - t) * log(1 - p + .0000001);
    delta[hook(3, i)] = t - p;
  }
}