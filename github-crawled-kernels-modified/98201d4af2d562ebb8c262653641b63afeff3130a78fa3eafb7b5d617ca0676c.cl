//{"height":3,"input":0,"output":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bitSplicing(global int* input, global int* output, int width, int height) {
  unsigned int x = get_global_id(0);
  unsigned int y = get_global_id(1);

  int toDivide = 128;
  output[hook(1, x + y * width)] = ((input[hook(0, x + y * width)] & toDivide) != 0) ? 0 : 255;
}