//{"err":10,"errors":1,"errors_ofs":3,"grad":11,"grad_ofs":5,"gradient":6,"inp":9,"inputs":0,"inputs_ofs":2,"inputs_per_neuron":4,"temp_mem":8,"weights_count":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float beta = 0.66666f;
kernel void calc_layer_gradient(global const float* inputs, global const float* errors, int inputs_ofs, int errors_ofs, int inputs_per_neuron, int grad_ofs, global float* gradient, int weights_count, local float* temp_mem) {
  int i = get_global_id(0);

  global const float* err = errors + errors_ofs;
  global const float* inp = inputs + inputs_ofs;
  global float* grad = gradient + grad_ofs;

  int input_index = i % inputs_per_neuron;
  int error_index = i / inputs_per_neuron;

  int lid = get_local_id(0);
  int lid_inp = lid % inputs_per_neuron;
  int lid_div_inp = lid / inputs_per_neuron;

  if (lid < inputs_per_neuron)
    temp_mem[hook(8, lid)] = input_index == 0 ? 1.0 : inp[hook(9, input_index - 1)];
  if (lid_inp == 0)
    temp_mem[hook(8, inputs_per_neuron + lid_div_inp)] = err[hook(10, error_index)];

  float g = grad[hook(11, i)];

  barrier(0x01);

  if (i >= weights_count)
    return;

  float e = temp_mem[hook(8, inputs_per_neuron + lid_div_inp)] * temp_mem[hook(8, lid_inp)];
  grad[hook(11, i)] = g + e;
}