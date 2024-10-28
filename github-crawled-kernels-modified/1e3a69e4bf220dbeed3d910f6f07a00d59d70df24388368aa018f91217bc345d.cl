//{"input":0,"output":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void blur2d(global float* input, global float* output, unsigned int width) {
  int globalX = get_global_id(0) + 1;
  int globalY = get_global_id(1) + 1;

  float result = 0.5f * (input[hook(0, (globalX) * width + (globalY))]) + 0.1f * (input[hook(0, (globalX - 1) * width + (globalY))]) + 0.1f * (input[hook(0, (globalX + 1) * width + (globalY))]) + 0.1f * (input[hook(0, (globalX) * width + (globalY - 1))]) + 0.1f * (input[hook(0, (globalX) * width + (globalY + 1))]);

  (output[hook(1, (globalX) * width + (globalY))]) = result;
}