//{"inputs":0,"inputs_ofs":2,"inputs_per_neuron":5,"neuron_count":6,"outputs":8,"outputs_ofs":4,"partial_sum":7,"row":9,"weights":1,"weights_ofs":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float beta = 0.66666f;
kernel void process_layer(global const float* inputs, global const float* weights, int inputs_ofs, int weights_ofs, int outputs_ofs, int inputs_per_neuron, int neuron_count, local float* partial_sum, global float* outputs) {
  for (unsigned int y = get_group_id(0); y < neuron_count; y += get_num_groups(0)) {
    const global float* row = weights + weights_ofs + y * inputs_per_neuron;

    int lid = get_local_id(0);
    int sum_start = lid;

    float sum;
    if (lid == 0) {
      sum = row[hook(9, 0)];
      sum_start = get_local_size(0);
    } else
      sum = 0.0f;

    for (unsigned int x = sum_start; x < inputs_per_neuron; x += get_local_size(0))
      sum += row[hook(9, x)] * inputs[hook(0, x - 1 + inputs_ofs)];

    partial_sum[hook(7, lid)] = sum;

    for (unsigned int stride = get_local_size(0) / 2; stride > 0; stride /= 2) {
      barrier(0x01);
      if (lid < stride)
        partial_sum[hook(7, lid)] += partial_sum[hook(7, lid + stride)];
    }

    if (lid == 0)
      outputs[hook(8, y + outputs_ofs)] = tanh(beta * partial_sum[hook(7, 0)]);

    barrier(0x01);
  }
}