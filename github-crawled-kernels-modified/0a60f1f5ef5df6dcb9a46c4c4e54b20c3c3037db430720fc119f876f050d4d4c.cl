//{"count":4,"image1dInput":1,"input":0,"outputFloat":2,"outputImage":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void image1d_type(global float* input, image1d_t image1dInput, global float* outputFloat, global float* outputImage, unsigned int count) {
  unsigned int i = get_global_id(0);
  if (i < count) {
    outputFloat[hook(2, i)] = input[hook(0, i)];
  }
}