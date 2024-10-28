//{"err":2,"factor":3,"nx":1,"soa":0,"soa->x":4,"soa->y":5}
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

kernel void multiformat_opencl(global struct struct_of_arrays* soa, unsigned int nx, global int* err, int factor) {
  const int i = get_global_id(0);
  if (i >= nx)
    return;

  if (soa->x[hook(4, i)] != i * factor || soa->y[hook(5, i)] != i * factor) {
    *err = i;
  } else {
    soa->x[hook(4, i)] = -soa->x[hook(4, i)];
    soa->y[hook(5, i)] = -soa->y[hook(5, i)];
  }
}