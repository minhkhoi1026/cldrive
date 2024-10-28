//{"count":2,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void plus_1d(global float* input, global float* output, const unsigned int count) {
  unsigned int global_index = get_global_id(0);
  if (global_index < count) {
    float s = output[hook(1, global_index)];
    float a = input[hook(0, global_index)];
    for (long i = 0; i < 1024 * 1024 * 16; i++) {
      s = s + a;
    }
    output[hook(1, global_index)] = s;
  }
}