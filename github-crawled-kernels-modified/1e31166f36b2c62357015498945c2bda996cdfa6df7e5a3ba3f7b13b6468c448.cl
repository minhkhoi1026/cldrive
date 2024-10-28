//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transform_fc1(global float* input, global float* output) {
  output[hook(1, get_local_id(2) * ((((28 - 5 + 1) / 2) - 5 + 1) / 2) * ((((28 - 5 + 1) / 2) - 5 + 1) / 2) * 128 + get_local_id(1) * ((((28 - 5 + 1) / 2) - 5 + 1) / 2) * 128 + get_local_id(0) * 128 + get_group_id(0))] = input[hook(0, get_local_id(1) * ((((28 - 5 + 1) / 2) - 5 + 1) / 2) * 64 * 128 + get_local_id(0) * 64 * 128 + get_local_id(2) * 128 + get_group_id(0))];
}