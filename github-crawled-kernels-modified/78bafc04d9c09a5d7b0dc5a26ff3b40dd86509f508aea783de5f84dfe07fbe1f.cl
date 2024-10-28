//{"W":1,"dX":0,"dY":2,"input_units":3,"neurons":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BIASED_MATRIX_VECTOR_BWD(global float* dX, global float* W, global float* dY, unsigned int input_units, unsigned int neurons) {
  unsigned int input_neuron = get_global_id(0);
  unsigned int sample = get_global_id(1);

  float sum = 0;

  for (unsigned int o = 0; o < neurons; o++) {
    const float W_val = W[hook(1, input_neuron * neurons + o)];
    const float dY_val = dY[hook(2, sample * neurons + o)];
    sum += W_val * dY_val;
  }

  dX[hook(0, input_neuron + sample * input_units)] = sum;
}