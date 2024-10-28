//{"height":3,"input":0,"output":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned char logconv(unsigned char in) {
  return 25 * log((float)in + 1);
}

kernel void render(global char* input, global char* output, int width, int height) {
  unsigned int i = get_global_id(0);

  unsigned int i_mul_4 = i * 4;

  output[hook(1, i_mul_4)] = logconv(input[hook(0, i_mul_4)]);
  output[hook(1, i_mul_4 + 1)] = logconv(input[hook(0, i_mul_4 + 1)]);
  output[hook(1, i_mul_4 + 2)] = logconv(input[hook(0, i_mul_4 + 2)]);
  output[hook(1, i_mul_4 + 3)] = input[hook(0, i_mul_4 + 3)];
}