//{"a":2,"size":3,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void SAXPY(global const float* restrict x, global float* restrict y, const int a, const int size) {
  for (int i = 0; i < size; i++)
    y[hook(1, i)] = a * x[hook(0, i)] + y[hook(1, i)];
}