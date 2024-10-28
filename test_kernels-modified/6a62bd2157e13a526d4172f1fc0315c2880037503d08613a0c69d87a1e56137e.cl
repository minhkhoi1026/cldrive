//{"dim_hidden":4,"dim_in":5,"in":2,"out":0,"tmp":3,"weight":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float sigmoid(float z) {
  return 1.0f / (1.0f + exp(-z));
}
inline float sigmoid_gradient(float y) {
  return y * (1.0f - y);
}

inline float relu(float z) {
  return z > 0 ? z : 0;
}
inline float relu_gradient(float y) {
  return y > 0 ? 1 : 0;
}

inline float tanh_gradient(float y) {
  return 1.0f - y * y;
}

inline float softrelu(float z) {
  return log(1.0f + exp(z));
}
inline float softrelu_gradient(float y) {
  return 1.0f - exp(-y);
}

inline float leakyrelu(float z) {
  return z > 0 ? z : 0.25f * z;
}
inline float leakyrelu_gradient(float y) {
  return y > 0 ? 1 : 0.25f;
}

inline float linear_regression(float y, float label) {
  float delta = y - label;
  return delta * delta;
}
inline float linear_regression_gradient(float y, float label) {
  return y - label;
}

inline float negative_log_likelihood_gradient(float y, bool i_equal_j) {
  return i_equal_j ? y - 1.0f : y;
}

kernel void parallel_multiply(global float* out, const global float* weight, const global float* in, local float* tmp, const int dim_hidden, const int dim_in) {
  const int GID = get_global_id(0);
  const int parallel = get_local_size(0);
  const int k = GID / parallel;
  const int n = k / dim_hidden;
  const int hidden = k % dim_hidden;
  const int weight_offset = hidden * dim_in;
  const int in_offset = n * dim_in;
  float z = 0;

  const int pos = GID % parallel;
  float sum = 0;
  for (int index = pos; index < dim_in; index += parallel)
    sum += weight[hook(1, weight_offset + index)] * in[hook(2, in_offset + index)];

  tmp[hook(3, pos)] = sum;
  barrier(0x01);
  for (int stride = parallel / 2; stride > 0; stride = stride / 2) {
    if (pos < stride)
      tmp[hook(3, pos)] += tmp[hook(3, pos + stride)];
    barrier(0x01);
  }
  if (pos == 0)
    out[hook(0, k)] = softrelu(z + tmp[hook(3, 0)]);
}