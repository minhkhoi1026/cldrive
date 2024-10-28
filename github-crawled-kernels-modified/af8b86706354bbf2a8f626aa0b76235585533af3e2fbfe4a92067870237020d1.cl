//{"N":0,"expected":3,"input":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_kernel(int N, global float* input, global float* output, global float* expected) {
  int index = (get_group_id(0) + get_group_id(1) * get_num_groups(0)) * get_local_size(0) + get_local_id(0);

  if (index >= N)
    return;

  output[hook(2, index)] = sqrt(input[hook(1, index)]);

  index += 1;
  input[hook(1, index)] = output[hook(2, index - 1)];
  output[hook(2, index)] = log(input[hook(1, index)]);

  index += 1;
  input[hook(1, index)] = output[hook(2, index - 1)];
  output[hook(2, index)] = pow(input[hook(1, index)], output[hook(2, index - 2)]);

  index += 1;
  input[hook(1, index)] = output[hook(2, index - 1)];
  output[hook(2, index)] = -exp(input[hook(1, index)]);

  index += 1;
  input[hook(1, index)] = output[hook(2, index - 1)];
  output[hook(2, index)] = fabs(input[hook(1, index)]);

  index += 1;
  input[hook(1, index)] = output[hook(2, index - 1)];
  output[hook(2, index)] = sin(input[hook(1, index)]);

  index += 1;
  input[hook(1, index)] = output[hook(2, index - 1)];
  output[hook(2, index)] = cos(input[hook(1, index)]);
}