//{"X":0,"dW":1,"dY":2,"input_units":3,"local_lr":6,"neurons":4,"samples":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MATRIX_MATRIX(global float* X, global float* dW, global float* dY, unsigned int input_units, unsigned int neurons, unsigned int samples, float local_lr) {
  unsigned int output_neuron = get_global_id(0);
  unsigned int input_neuron = get_global_id(1);

  float sum = 0;

  for (unsigned int sample = 0; sample < samples; sample++) {
    const float X_val = X[hook(0, input_neuron + sample * input_units)];
    const float dY_val = dY[hook(2, output_neuron + sample * neurons)];
    sum += X_val * dY_val;
  }

  sum *= local_lr;

  dW[hook(1, input_neuron * neurons + output_neuron)] = sum;
}