//{"aop":0,"nx":2,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct struct_of_arrays {
  float *x, *y;
};

struct point {
  float x, y;
};
kernel void custom_opencl_conversion(global struct point* aop, global float* x, int nx) {
  const int i = get_global_id(0);
  if (i < nx / 2)
    x[hook(1, i)] = aop[hook(0, i)].x;
  else if (i < nx)
    x[hook(1, i)] = aop[hook(0, i - nx / 2)].y;
}