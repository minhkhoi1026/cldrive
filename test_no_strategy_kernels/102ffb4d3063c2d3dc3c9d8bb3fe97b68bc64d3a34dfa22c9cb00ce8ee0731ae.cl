//{"a":0,"n":2,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void image_filter(global uchar* a, global uchar* output, int n) {
  size_t i = get_global_id(0);

  if (i * 3 + 2 >= n) {
    return;
  }

  int pixel = i * 3;
  uchar sum = (a[hook(0, pixel)] + a[hook(0, pixel + 1)] + a[hook(0, pixel + 2)]) / 3;

  output[hook(1, pixel)] = sum;
  output[hook(1, pixel + 1)] = sum;
  output[hook(1, pixel + 2)] = sum;
}