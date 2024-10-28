//{"act":5,"local_input":6,"nInputs":3,"pBias":4,"pInput":0,"pOutput":2,"pWeights":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((num_simd_work_items(4))) __attribute__((reqd_work_group_size(8, 1, 1))) kernel void fc_layer_relu(const global float* restrict pInput, const global float* restrict pWeights, global float* restrict pOutput, const int nInputs, const global float* restrict pBias, const unsigned char act) {
  const int gx = get_global_id(0);

  const int lx = get_local_id(0);
  const int ls = get_local_size(0);
  local float local_input[256 * 6 * 6];
  int inputs_per_item = nInputs / ls;
  int rem_inputs = nInputs - inputs_per_item * ls;
  for (int item = 0; item < inputs_per_item; item++) {
    local_input[hook(6, item * ls + lx)] = pInput[hook(0, item * ls + lx)];
  }

  if (lx < rem_inputs) {
    local_input[hook(6, ls * inputs_per_item + lx)] = pInput[hook(0, ls * inputs_per_item + lx)];
  }
  barrier(0x01);

  const int idxstart = gx * nInputs;
  float sum = 0;
  float zero = 0;
  for (int i = 0; i < nInputs; i++) {
    sum += pWeights[hook(1, idxstart + i)] * local_input[hook(6, i)];
  }
  sum += pBias[hook(4, gx)];
  if (act == 1) {
    pOutput[hook(2, gx)] = fmax(zero, sum);
  } else {
    pOutput[hook(2, gx)] = sum;
  }
}