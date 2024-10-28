//{"W":1,"X":0,"Y":3,"b":2,"input_units":4,"neurons":5,"weight_factor":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BIASED_MATRIX_VECTOR_FWD(global float* X, global float* W, global float* b, global float* Y, unsigned int input_units, unsigned int neurons, float weight_factor) {
  unsigned int output_neuron = get_global_id(0);
  unsigned int sample = get_global_id(1);

  float sum = 0;

  for (unsigned int i = 0; i < input_units; i++) {
    const float W_val = W[hook(1, i * neurons + output_neuron)];
    const float X_val = X[hook(0, i + sample * input_units)];
    sum += W_val * X_val;
  }

  sum *= weight_factor;
  sum += b[hook(2, output_neuron)];

  Y[hook(3, sample * neurons + output_neuron)] = sum;
}