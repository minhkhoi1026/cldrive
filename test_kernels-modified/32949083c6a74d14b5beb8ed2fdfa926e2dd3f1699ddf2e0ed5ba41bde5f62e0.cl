//{"bias_buffer":0,"db":1,"local_lr":4,"output_maps":2,"samples":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BIAS_GRADIENT_PART2(global float* bias_buffer, global float* db, unsigned int output_maps, unsigned int samples, float local_lr) {
  const unsigned int output_map = get_global_id(0);
  float sum = 0;
  for (unsigned int sample = 0; sample < samples; sample++) {
    const float bias_buffer_val = bias_buffer[hook(0, sample * output_maps + output_map)];
    sum += bias_buffer_val;
  }

  sum *= (local_lr);

  db[hook(1, output_map)] = sum;
}