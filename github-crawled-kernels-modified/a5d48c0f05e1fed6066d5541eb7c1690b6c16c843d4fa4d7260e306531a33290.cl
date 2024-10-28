//{"C":0,"cell_no":6,"data":7,"dim_hidden":5,"gates_data":2,"h":1,"tmp":4,"z":3}
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

kernel void feed_forward_LSTM_cell(global float* C, global float* h, global float* gates_data, const global float* z, local float* tmp, const int dim_hidden, int cell_no) {
  const int GID = get_global_id(0);
  const int batch = GID / dim_hidden;
  const int i_g = batch * 4 * dim_hidden + (GID % dim_hidden);
  const int i_t = i_g + dim_hidden;
  const int f_g = i_t + dim_hidden;
  const int o_g = f_g + dim_hidden;
  const float in_gate = sigmoid(z[hook(3, i_g)]);
  const float C_candicate = tanh(z[hook(3, i_t)]);
  const float forget_gate = sigmoid(z[hook(3, f_g)]);
  const float out_gate = sigmoid(z[hook(3, o_g)]);
  const float C_prev = C[hook(0, GID)];
  const float C_t = forget_gate * C_prev + in_gate * C_candicate;
  const float tanh_C_t = tanh(C_t);

  if (gates_data != ((void*)0)) {
    global float* data = gates_data + cell_no * get_global_size(0) * 7;

    const float C_grad = out_gate * tanh_gradient(tanh_C_t);
    data[hook(7, i_g)] = C_candicate * sigmoid_gradient(in_gate);
    data[hook(7, i_t)] = in_gate * tanh_gradient(C_candicate);
    data[hook(7, f_g)] = C_prev * sigmoid_gradient(forget_gate);
    data[hook(7, o_g)] = tanh_C_t * sigmoid_gradient(out_gate);

    const int p = 4 * get_global_size(0) + GID;
    const int c_g = p + get_global_size(0);
    const int c_m = c_g + get_global_size(0);
    data[hook(7, p)] = h[hook(1, GID)];
    data[hook(7, c_g)] = C_grad;
    data[hook(7, c_m)] = forget_gate;
  }
  C[hook(0, GID)] = C_t;
  h[hook(1, GID)] = out_gate * tanh_C_t;
}