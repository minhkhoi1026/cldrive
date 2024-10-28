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

kernel void custom_scal_opencl(global struct point* aop, global float* x, int nx) {
  const int i = get_global_id(0);
  if (i < nx)
    x[hook(1, i)] *= x[hook(1, i + nx)];
}