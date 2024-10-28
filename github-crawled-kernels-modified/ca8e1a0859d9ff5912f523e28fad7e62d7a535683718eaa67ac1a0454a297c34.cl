//{"input_output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void square(global float* input_output) {
  size_t id = get_global_id(0);
  float value = input_output[hook(0, id)];
  input_output[hook(0, id)] = value * value;
}