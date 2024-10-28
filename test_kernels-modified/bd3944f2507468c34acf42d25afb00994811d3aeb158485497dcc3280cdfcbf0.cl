//{"height":3,"in":0,"out":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Stencil1(global float* in, global float* out, int width, int height) {
  int num = get_global_id(0);

  if (num < width || (num % width) == 0 || (num % width) == width - 1 || num >= (width * height - width)) {
    out[hook(1, num)] = in[hook(0, num)];
  } else {
    out[hook(1, num)] = (in[hook(0, num - 1)] + in[hook(0, num + 1)] + in[hook(0, num - width)] + in[hook(0, num + width)]) / 4;
  }
}