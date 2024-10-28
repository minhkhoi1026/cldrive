//{"dst":1,"dst->x":3,"dst->y":4,"n":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct struct_of_arrays {
  float x[10];
  float y[10];
};
struct point {
  float x, y;
};

kernel void cpu_to_opencl_opencl(global struct point* src, global struct struct_of_arrays* dst, unsigned int n) {
  const unsigned int i = get_global_id(0);
  if (i < n) {
    dst->x[hook(3, i)] = src[hook(0, i)].x;
    dst->y[hook(4, i)] = src[hook(0, i)].y;
  }
}