//{"len":3,"result":2,"x":0,"x_diff":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel __attribute((reqd_work_group_size(1, 1, 1))) void softmax_float(global float* x, global float* result, const unsigned int len) {
  float in_max = -0x1.fffffep127f;
  float sum = 0.0;
  unsigned int i;
  for (i = 0; i < len; i++) {
    float current = x[hook(0, i)];
    in_max = (in_max > current) ? in_max : current;
  }
  for (i = 0; i < len; i++) {
    float current = exp(x[hook(0, i)] - in_max);
    sum += current;
    result[hook(2, i)] = current;
  }
  for (i = 0; i < len; i++) {
    result[hook(2, i)] = (result[hook(2, i)] / sum);
  }
}

kernel __attribute((reqd_work_group_size(1, 1, 1))) void log_softmax_float(global float* x, global float* result, const unsigned int len) {
  float in_max = -0x1.fffffep127f;
  float sum = 0.0;
  unsigned int i;
  for (i = 0; i < len; i++) {
    float current = x[hook(0, i)];
    in_max = (in_max > current) ? in_max : current;
  }
  for (i = 0; i < len; i++) {
    float current = exp(x[hook(0, i)] - in_max);
    sum += current;
    result[hook(2, i)] = current;
  }
  for (i = 0; i < len; i++) {
    result[hook(2, i)] = (log(result[hook(2, i)] / sum));
  }
}

kernel void log_softmax_backward_float(global float* x, global float* x_diff, global float* result, const unsigned int len) {
  float sum = 0.0;
  unsigned int i;
  for (i = 0; i < len; i++) {
    sum += x_diff[hook(1, i)];
  }
  for (i = 0; i < len; i++) {
    result[hook(2, i)] = x_diff[hook(1, i)] - exp(x[hook(0, i)]) * sum;
  }
}