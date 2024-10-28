//{"dY":1,"db":0,"local_lr":4,"neurons":2,"samples":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BIASED_MATRIX_VECTOR_GRAD(global float* db, global float* dY, unsigned int neurons, unsigned int samples, float local_lr) {
  unsigned int output_neuron = get_global_id(0);

  float sum = 0;
  for (unsigned int sample = 0; sample < samples; sample++) {
    const float dY_val = dY[hook(1, output_neuron + sample * neurons)];
    sum += dY_val;
  }

  sum *= local_lr;

  db[hook(0, output_neuron)] = sum;
}