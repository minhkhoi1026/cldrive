//{"batch_size":12,"bias_grad":2,"cell_no":13,"data":14,"dim_hidden":11,"dim_input":10,"gates_data":5,"h_grad":3,"tmp":9,"weight_h":7,"weight_h_grad":0,"weight_x":8,"weight_x_grad":1,"x":6,"x_grad":4}
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

kernel void back_propagate_fully_connected_LSTM_cell(global float* weight_h_grad, global float* weight_x_grad, global float* bias_grad, global float* h_grad, global float* x_grad, const global float* gates_data, const global float* x, const global float* weight_h, const global float* weight_x, local float* tmp, const int dim_input, const int dim_hidden, const int batch_size, const int cell_no) {
  const int GID = get_global_id(0);
  const int parallel = get_local_size(0);
  const int j = GID / parallel;
  const int K = GID % parallel;
  const int i_g = j;
  const int i_t = i_g + dim_hidden;
  const int f_g = i_t + dim_hidden;
  const int o_g = f_g + dim_hidden;
  gates_data += cell_no * dim_hidden * batch_size * 7;

  const global float* data = gates_data;
  for (int k = K; k < dim_hidden; k += parallel)
    for (int n = 0; n < batch_size; n++) {
      const float h_prev = data[hook(14, 4 * dim_hidden + k)];
      const float h_grad_batch_one = h_grad[hook(3, n * dim_hidden + j)] / batch_size;
      weight_h_grad[hook(0, i_g * dim_hidden + k)] += h_grad_batch_one * data[hook(14, i_g)] * h_prev;
      weight_h_grad[hook(0, i_t * dim_hidden + k)] += h_grad_batch_one * data[hook(14, i_t)] * h_prev;
      weight_h_grad[hook(0, f_g * dim_hidden + k)] += h_grad_batch_one * data[hook(14, f_g)] * h_prev;
      weight_h_grad[hook(0, o_g * dim_hidden + k)] += h_grad_batch_one * data[hook(14, o_g)] * h_prev;
      data += dim_hidden * 5;
    }

  data = gates_data;
  for (int k = K; k < dim_input; k += parallel)
    for (int n = 0; n < batch_size; n++) {
      const float in = x[hook(6, n * dim_input + k)];
      const float h_grad_batch_one = h_grad[hook(3, n * dim_hidden + j)] / batch_size;
      weight_x_grad[hook(1, i_g * dim_input + k)] += h_grad_batch_one * data[hook(14, i_g)] * in;
      weight_x_grad[hook(1, i_t * dim_input + k)] += h_grad_batch_one * data[hook(14, i_t)] * in;
      weight_x_grad[hook(1, f_g * dim_input + k)] += h_grad_batch_one * data[hook(14, f_g)] * in;
      weight_x_grad[hook(1, o_g * dim_input + k)] += h_grad_batch_one * data[hook(14, o_g)] * in;
      data += dim_hidden * 5;
    }

  data = gates_data;
  if (K == 0)
    for (int n = 0; n < batch_size; n++) {
      const float h_grad_batch_one = h_grad[hook(3, n * dim_hidden + j)] / batch_size;
      bias_grad[hook(2, i_g)] += h_grad_batch_one * data[hook(14, i_g)];
      bias_grad[hook(2, i_t)] += h_grad_batch_one * data[hook(14, i_t)];
      bias_grad[hook(2, f_g)] += h_grad_batch_one * data[hook(14, f_g)];
      bias_grad[hook(2, o_g)] += h_grad_batch_one * data[hook(14, o_g)];

      for (int k = 0; k < dim_hidden; k++)
        h_grad[hook(3, n * dim_hidden + j)] += h_grad_batch_one * (data[hook(14, k)] + data[hook(14, k + dim_hidden)] + data[hook(14, k + 2 * dim_hidden)] + data[hook(14, k + 3 * dim_hidden)]) * weight_h[hook(7, k * dim_hidden + j)];
      data += dim_hidden * 5;
    }

  data = gates_data;
  for (int k = K; k < dim_input; k += parallel)
    for (int n = 0; n < batch_size; n++) {
      const float weight = weight_x[hook(8, n * dim_input + k)];
      const float h_grad_batch_one = h_grad[hook(3, n * dim_hidden + j)] / batch_size;
      x_grad[hook(4, i_g * dim_input + k)] = h_grad_batch_one * data[hook(14, i_g)] * weight_x[hook(8, i_g * dim_input + k)];
      x_grad[hook(4, i_t * dim_input + k)] = h_grad_batch_one * data[hook(14, i_t)] * weight_x[hook(8, i_t * dim_input + k)];
      x_grad[hook(4, f_g * dim_input + k)] = h_grad_batch_one * data[hook(14, f_g)] * weight_x[hook(8, f_g * dim_input + k)];
      x_grad[hook(4, o_g * dim_input + k)] = h_grad_batch_one * data[hook(14, o_g)] * weight_x[hook(8, o_g * dim_input + k)];
      data += dim_hidden * 5;
    }
}