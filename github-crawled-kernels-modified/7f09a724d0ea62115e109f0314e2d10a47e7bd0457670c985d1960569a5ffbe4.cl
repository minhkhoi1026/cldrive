//{"a":2,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void SAXPY(global float* x, global float* y, float a) {
  const int i = get_global_id(0);

  y[hook(1, i)] += a * x[hook(0, i)];
}