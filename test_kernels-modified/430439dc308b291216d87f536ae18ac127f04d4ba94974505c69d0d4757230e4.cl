//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_func(global const float* input, global float* output) {
  int i = get_global_id(0);

  if (i & 0x1) {
    return;
  }

  float a = input[hook(0, i)];
  float b = input[hook(0, i + 1)];

  output[hook(1, i)] = b;
  output[hook(1, i + 1)] = a;
}