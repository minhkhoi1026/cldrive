//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecadd(global const float* a, global const float* b, global float* c) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int width = get_global_size(0);
  int height = get_global_size(1);

  c[hook(2, x + y * width)] = a[hook(0, x + y * width)] + b[hook(1, x + y * width)];
}