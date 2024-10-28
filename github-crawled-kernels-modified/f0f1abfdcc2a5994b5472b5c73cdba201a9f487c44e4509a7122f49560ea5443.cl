//{"height":3,"input":1,"output":0,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mtranReference(global float* output, global float* input, const int width, const int height) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  output[hook(0, y * width + x)] = input[hook(1, x * height + y)];
}