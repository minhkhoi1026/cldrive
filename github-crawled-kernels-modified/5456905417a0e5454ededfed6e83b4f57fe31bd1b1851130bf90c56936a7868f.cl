//{"a":0,"b":1,"c":2,"count":4,"d":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vadd(global float* a, global float* b, global float* c, global float* d, const unsigned int count) {
  int i = get_global_id(0);
  if (i < count) {
    d[hook(3, i)] = a[hook(0, i)] + b[hook(1, i)] + c[hook(2, i)];
  }
}