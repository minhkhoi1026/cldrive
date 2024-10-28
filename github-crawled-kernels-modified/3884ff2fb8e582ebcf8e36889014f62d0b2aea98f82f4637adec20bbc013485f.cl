//{"batch_size":6,"dim_in":5,"in":2,"label":3,"out":1,"out_grad":0,"tmp":4}
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

kernel void negative_log_likelihood_loss(global float* out_grad, global float* out, const global float* in, const global float* label, local float* tmp, const int dim_in, const int batch_size) {
  const int GID = get_global_id(0);
  const int parallel = get_local_size(0);
  const int n = GID / parallel;
  const int pos = GID % parallel;

  float max_value = in[hook(2, n * dim_in)];
  for (int index = 1; index < dim_in; index++)
    max_value = max(max_value, in[hook(2, n * dim_in + index)]);

  float sum = 0;
  for (int index = pos; index < dim_in; index += parallel) {
    const int k = n * dim_in + index;
    out[hook(1, k)] = exp(in[hook(2, k)] - max_value);
    sum += out[hook(1, k)];
  }

  tmp[hook(4, pos)] = sum;
  barrier(0x01);
  for (int stride = parallel / 2; stride > 0; stride = stride / 2) {
    if (pos < stride)
      tmp[hook(4, pos)] += tmp[hook(4, pos + stride)];
    barrier(0x01);
  }
  sum = tmp[hook(4, 0)];

  for (int index = pos; index < dim_in; index += parallel) {
    const int i = ((int)label[hook(3, n)]), k = n * dim_in + index;
    out[hook(1, k)] /= sum;
    out_grad[hook(0, k)] = negative_log_likelihood_gradient(out[hook(1, k)], index == i) / batch_size;
  }
}