//{"a":2,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void saxpy(global float* x, global float* y, const float a) {
  const unsigned int i = get_global_id(0);
  y[hook(1, i)] = a * x[hook(0, i)] + y[hook(1, i)];
}