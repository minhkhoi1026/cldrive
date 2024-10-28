//{"err":2,"factor":3,"nx":1,"val":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_csr_opencl(global int* val, unsigned int nx, global int* err, int factor) {
  const int i = get_global_id(0);
  if (i >= nx)
    return;

  if (val[hook(0, i)] != (i + 1) * factor)
    *err = 1;
  else
    val[hook(0, i)] = -val[hook(0, i)];
}