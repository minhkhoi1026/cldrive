//{"count":4,"errors":0,"errors_count":5,"errors_ofs":2,"inputs_per_neuron":7,"ofs":3,"outputs":9,"partial_sum":8,"wcol":10,"weights":1,"weights_offset":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float beta = 0.66666f;
kernel void propagate_errors(global float* errors, global const float* weights, int errors_ofs, int ofs, int count, int errors_count, int weights_offset, int inputs_per_neuron, local float* partial_sum, global const float* outputs) {
  for (unsigned int y = get_group_id(0); y < count; y += get_num_groups(0)) {
    const global float* wcol = weights + weights_offset + y;

    int lid = get_local_id(0);

    float sum = 0.0f;
    for (unsigned int x = lid; x < errors_count; x += get_local_size(0))
      sum += wcol[hook(10, x * inputs_per_neuron)] * errors[hook(0, x + errors_ofs)];

    partial_sum[hook(8, lid)] = sum;

    for (unsigned int stride = get_local_size(0) / 2; stride > 0; stride /= 2) {
      barrier(0x01);
      if (lid < stride)
        partial_sum[hook(8, lid)] += partial_sum[hook(8, lid + stride)];
    }

    if (lid == 0) {
      float output = outputs[hook(9, y + ofs)];
      errors[hook(0, y + ofs)] += partial_sum[hook(8, 0)] * beta * (1.0f - output * output);
    }

    barrier(0x01);
  }
}