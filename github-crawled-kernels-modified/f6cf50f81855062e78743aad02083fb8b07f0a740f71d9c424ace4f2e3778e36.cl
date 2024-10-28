//{"nx":2,"tmp":1,"val":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void increment_vector_opencl(global unsigned* val, global unsigned* tmp, unsigned nx) {
  const int id = get_global_id(0);

  if (id < nx)
    val[hook(0, id)] = tmp[hook(1, id)] + 1;
}