//{"alpha":1,"n":0,"offx":3,"offy":5,"x":2,"y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void axpy_float(const int n, const float alpha, global const float* x, const int offx, global float* y, const int offy) {
  for (int index = get_global_id(0); index < n; index += get_global_size(0)) {
    float src = x[hook(2, offx + index)];
    float dst = y[hook(4, offy + index)];
    y[hook(4, offy + index)] = alpha * src + dst;
  }
}