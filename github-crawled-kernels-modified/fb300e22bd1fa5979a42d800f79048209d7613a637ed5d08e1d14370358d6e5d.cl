//{"hid":7,"hidden_partial_sum":3,"in":6,"input_cuda":0,"input_hidden_cuda":2,"input_node":4,"output_hidden_cuda":1,"weight_matrix":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bpnn_layerforward_ocl(global float* restrict input_cuda, global float* restrict output_hidden_cuda, global float* restrict input_hidden_cuda, global float* restrict hidden_partial_sum, local float* restrict input_node, local float* restrict weight_matrix, int in, int hid) {
  int by = get_group_id(1);
  int tx = get_local_id(0);
  int ty = get_local_id(1);

  int index = (hid + 1) * 16 * by + (hid + 1) * ty + tx + 1 + (hid + 1);

  int index_in = 16 * by + ty + 1;

  if (tx == 0) {
    input_node[hook(4, ty)] = input_cuda[hook(0, index_in)];
  }
  barrier(0x01);

  weight_matrix[hook(5, ty * 16 + tx)] = input_hidden_cuda[hook(2, index)];
  barrier(0x01);

  weight_matrix[hook(5, ty * 16 + tx)] = weight_matrix[hook(5, ty * 16 + tx)] * input_node[hook(4, ty)];
  barrier(0x01);

  for (int i = 1; i <= 16; i = i * 2) {
    int power_two = i;

    if (ty % power_two == 0) {
      weight_matrix[hook(5, ty * 16 + tx)] = weight_matrix[hook(5, ty * 16 + tx)] + weight_matrix[hook(5, (ty + power_two / 2) * 16 + tx)];
    }

    barrier(0x01);
  }

  input_hidden_cuda[hook(2, index)] = weight_matrix[hook(5, ty * 16 + tx)];

  barrier(0x01);

  if (tx == 0) {
    hidden_partial_sum[hook(3, by * hid + ty)] = weight_matrix[hook(5, tx * 16 + ty)];
  }
}