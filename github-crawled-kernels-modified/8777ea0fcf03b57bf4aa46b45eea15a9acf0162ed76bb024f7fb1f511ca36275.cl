//{"batch_size":7,"cell_no":8,"cell_state_grad":2,"data":9,"dim_hidden":6,"gates_data":4,"h_grad":3,"h_prev":1,"tmp":5,"z_grad":0}
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

kernel void back_propagate_LSTM_cell_gates(global float* z_grad, global float* h_prev, global float* cell_state_grad, const global float* h_grad, const global float* gates_data, local float* tmp, const int dim_hidden, const int batch_size, const int cell_no) {
  const int GID = get_global_id(0);
  const int batch = GID / dim_hidden;
  const int i_g = batch * 4 * dim_hidden + (GID % dim_hidden);
  const int i_t = i_g + dim_hidden;
  const int f_g = i_t + dim_hidden;
  const int o_g = f_g + dim_hidden;
  const int p = 4 * get_global_size(0) + GID;
  const int c_g = p + get_global_size(0);
  const int c_m = c_g + get_global_size(0);

  const global float* data = gates_data + cell_no * get_global_size(0) * 7;
  const float h_grad_batch_one = h_grad[hook(3, GID)];
  const float C_grad = data[hook(9, c_g)];
  const float forget_gate = data[hook(9, c_m)];
  const float cell_grad = h_grad_batch_one * C_grad + cell_state_grad[hook(2, GID)];

  z_grad[hook(0, i_g)] = cell_grad * data[hook(9, i_g)];
  z_grad[hook(0, i_t)] = cell_grad * data[hook(9, i_t)];
  z_grad[hook(0, f_g)] = cell_grad * data[hook(9, f_g)];
  z_grad[hook(0, o_g)] = h_grad_batch_one * data[hook(9, o_g)];
  h_prev[hook(1, GID)] = data[hook(9, p)];
  cell_state_grad[hook(2, GID)] = cell_grad * forget_gate;
}