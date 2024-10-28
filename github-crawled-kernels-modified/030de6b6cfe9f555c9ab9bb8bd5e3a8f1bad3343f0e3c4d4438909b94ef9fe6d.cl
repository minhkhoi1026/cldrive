//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transform_conv1(global float* input, global float* output) {
  output[hook(1, get_local_id(2) * 5 * 5 + get_local_id(1) * 5 + get_local_id(0))] = input[hook(0, get_local_id(1) * 5 * 32 + get_local_id(0) * 32 + get_local_id(2))];
}