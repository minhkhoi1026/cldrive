//{"x":0,"y":1,"z":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vector_add(global const float* x, global const float* y, global float* restrict z) {
  int index = get_global_id(0);

  z[hook(2, index)] = x[hook(0, index)] + y[hook(1, index)];
}