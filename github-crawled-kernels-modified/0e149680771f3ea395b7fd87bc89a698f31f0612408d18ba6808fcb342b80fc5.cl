//{"a":0,"x":1,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void saxpy(float a, global float* x, global float* y) {
  unsigned int id = get_global_id(0);
  y[hook(2, id)] = a * x[hook(1, id)] + y[hook(2, id)];
}