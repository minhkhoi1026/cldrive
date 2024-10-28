//{"nx":1,"soa":0,"soa->x":2,"soa->y":3}
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

kernel void multiformat_opencl(global struct struct_of_arrays* soa, int nx) {
  const int i = get_global_id(0);
  if (i < nx)
    soa->x[hook(2, i)] *= soa->y[hook(3, i)];
}