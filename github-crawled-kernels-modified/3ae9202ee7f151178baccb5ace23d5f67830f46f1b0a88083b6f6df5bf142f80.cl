//{"bias":3,"dim_hidden":5,"dim_in":6,"in":1,"out":0,"tmp":4,"weight":2}
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

kernel void feed_forward_fully_connected_softrelu(global float* out, const global float* in, const global float* weight, const global float* bias, local float* tmp, const int dim_hidden, const int dim_in) {
  const int GID = get_global_id(0);

  const int parallel = get_local_size(0);
  const int n = GID / parallel / dim_hidden;
  const int hidden = (GID / parallel) % dim_hidden;

  const int in_offset = n * dim_in;
  float z = bias != ((void*)0) ? bias[hook(3, hidden)] : 0;

  const int pos = GID % parallel;
  float sum = 0;

  for (int index = pos; index < dim_in; index += parallel)
    sum += weight[hook(2, dim_hidden * index + hidden)] * in[hook(1, in_offset + index)];

  tmp[hook(4, pos)] = sum;
  barrier(0x01);
  for (int stride = parallel / 2; stride > 0; stride = stride / 2) {
    if (pos < stride)
      tmp[hook(4, pos)] += tmp[hook(4, pos + stride)];
    barrier(0x01);
  }
  if (pos == 0)
    out[hook(0, GID / parallel)] = softrelu(z + tmp[hook(4, 0)]);
}