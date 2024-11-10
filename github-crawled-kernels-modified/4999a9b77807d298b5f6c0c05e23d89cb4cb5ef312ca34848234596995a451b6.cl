//{"a":0,"b":1,"c":2,"vectorsLength":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add(global const float* a, global const float* b, global float* c, int vectorsLength) {
  int id = get_global_id(0);
  int nproc = get_global_size(0);
  int i;
  for (i = id; i < vectorsLength; i = i + nproc) {
    c[hook(2, i)] = a[hook(0, i)] + b[hook(1, i)];
  }
}