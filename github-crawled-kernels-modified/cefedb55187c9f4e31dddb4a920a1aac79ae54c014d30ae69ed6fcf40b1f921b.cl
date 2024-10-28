//{"batch_size":9,"bias_grad":2,"dim_in":8,"dim_out":7,"in":4,"in_grad":0,"out":5,"out_grad":6,"weight":3,"weight_grad":1}
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

kernel void back_propagate_fully_connected_softrelu_gradient(global float* in_grad, global float* weight_grad, global float* bias_grad, const global float* weight, const global float* in, const global float* out, const global float* out_grad, const int dim_out, const int dim_in, const int batch_size) {
  const int GID = get_global_id(0);
  const int k = GID % dim_in;
  const int n = GID / dim_in;

  if (n < dim_out) {
    float sum_weight_grad = 0, sum_bias_grad = 0;
    for (int j = 0; j < batch_size; j++) {
      const float in_j = in[hook(4, j * dim_in + k)];
      const float out_grad_j = softrelu_gradient(out[hook(5, j * dim_out + n)]) * out_grad[hook(6, j * dim_out + n)];
      sum_bias_grad += out_grad_j;
      sum_weight_grad += in_j * out_grad_j;
    }
    if (k == 0 && bias_grad != ((void*)0))
      bias_grad[hook(2, n)] += sum_bias_grad;
    weight_grad[hook(1, k * dim_out + n)] += sum_weight_grad;
  }

  if (in_grad != ((void*)0) && n < batch_size) {
    float sum_in_grad = 0;
    for (int j = 0; j < dim_out; j++) {
      const float weight_j = weight[hook(3, k * dim_out + j)];
      const float out_grad_j = softrelu_gradient(out[hook(5, n * dim_out + j)]) * out_grad[hook(6, n * dim_out + j)];
      sum_in_grad += weight_j * out_grad_j;
    }
    in_grad[hook(0, n * dim_in + k)] = sum_in_grad;
  }
}