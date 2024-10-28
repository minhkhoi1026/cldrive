//{"input":1,"output":0,"tile":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_transpose(global float* output, global float* input, local float* tile) {
  int block_x = get_group_id(0);
  int block_y = get_group_id(1);

  int local_x = get_local_id(0) & ((32) - 1);
  int local_y = get_local_id(0) >> (5);

  int local_input = mad24(local_y, (32) + 1, local_x);
  int local_output = mad24(local_x, (32) + 1, local_y);

  int in_x = mad24(block_x, (32), local_x);
  int in_y = mad24(block_y, (32), local_y);

  int input_index = mad24(in_y, (256), in_x);

  int out_x = mad24(block_y, (32), local_x);
  int out_y = mad24(block_x, (32), local_y);

  int output_index = mad24(out_y, (4096) + (32), out_x);

  int global_input_stride = (256) * (2);
  int global_output_stride = ((4096) + (32)) * (2);

  int local_input_stride = (2) * ((32) + 1);
  int local_output_stride = (2);

  tile[hook(2, local_input)] = input[hook(1, input_index)];
  local_input += local_input_stride;
  input_index += global_input_stride;

  tile[hook(2, local_input)] = input[hook(1, input_index)];
  local_input += local_input_stride;
  input_index += global_input_stride;

  tile[hook(2, local_input)] = input[hook(1, input_index)];
  local_input += local_input_stride;
  input_index += global_input_stride;

  tile[hook(2, local_input)] = input[hook(1, input_index)];
  local_input += local_input_stride;
  input_index += global_input_stride;

  tile[hook(2, local_input)] = input[hook(1, input_index)];
  local_input += local_input_stride;
  input_index += global_input_stride;

  tile[hook(2, local_input)] = input[hook(1, input_index)];
  local_input += local_input_stride;
  input_index += global_input_stride;

  tile[hook(2, local_input)] = input[hook(1, input_index)];
  local_input += local_input_stride;
  input_index += global_input_stride;

  tile[hook(2, local_input)] = input[hook(1, input_index)];
  local_input += local_input_stride;
  input_index += global_input_stride;

  tile[hook(2, local_input)] = input[hook(1, input_index)];
  local_input += local_input_stride;
  input_index += global_input_stride;

  tile[hook(2, local_input)] = input[hook(1, input_index)];
  local_input += local_input_stride;
  input_index += global_input_stride;

  tile[hook(2, local_input)] = input[hook(1, input_index)];
  local_input += local_input_stride;
  input_index += global_input_stride;

  tile[hook(2, local_input)] = input[hook(1, input_index)];
  local_input += local_input_stride;
  input_index += global_input_stride;

  tile[hook(2, local_input)] = input[hook(1, input_index)];
  local_input += local_input_stride;
  input_index += global_input_stride;

  tile[hook(2, local_input)] = input[hook(1, input_index)];
  local_input += local_input_stride;
  input_index += global_input_stride;

  tile[hook(2, local_input)] = input[hook(1, input_index)];
  local_input += local_input_stride;
  input_index += global_input_stride;

  tile[hook(2, local_input)] = input[hook(1, input_index)];

  barrier(0x01);

  output[hook(0, output_index)] = tile[hook(2, local_output)];
  local_output += local_output_stride;
  output_index += global_output_stride;

  output[hook(0, output_index)] = tile[hook(2, local_output)];
  local_output += local_output_stride;
  output_index += global_output_stride;

  output[hook(0, output_index)] = tile[hook(2, local_output)];
  local_output += local_output_stride;
  output_index += global_output_stride;

  output[hook(0, output_index)] = tile[hook(2, local_output)];
  local_output += local_output_stride;
  output_index += global_output_stride;

  output[hook(0, output_index)] = tile[hook(2, local_output)];
  local_output += local_output_stride;
  output_index += global_output_stride;

  output[hook(0, output_index)] = tile[hook(2, local_output)];
  local_output += local_output_stride;
  output_index += global_output_stride;

  output[hook(0, output_index)] = tile[hook(2, local_output)];
  local_output += local_output_stride;
  output_index += global_output_stride;

  output[hook(0, output_index)] = tile[hook(2, local_output)];
  local_output += local_output_stride;
  output_index += global_output_stride;

  output[hook(0, output_index)] = tile[hook(2, local_output)];
  local_output += local_output_stride;
  output_index += global_output_stride;

  output[hook(0, output_index)] = tile[hook(2, local_output)];
  local_output += local_output_stride;
  output_index += global_output_stride;

  output[hook(0, output_index)] = tile[hook(2, local_output)];
  local_output += local_output_stride;
  output_index += global_output_stride;

  output[hook(0, output_index)] = tile[hook(2, local_output)];
  local_output += local_output_stride;
  output_index += global_output_stride;

  output[hook(0, output_index)] = tile[hook(2, local_output)];
  local_output += local_output_stride;
  output_index += global_output_stride;

  output[hook(0, output_index)] = tile[hook(2, local_output)];
  local_output += local_output_stride;
  output_index += global_output_stride;

  output[hook(0, output_index)] = tile[hook(2, local_output)];
  local_output += local_output_stride;
  output_index += global_output_stride;

  output[hook(0, output_index)] = tile[hook(2, local_output)];
}