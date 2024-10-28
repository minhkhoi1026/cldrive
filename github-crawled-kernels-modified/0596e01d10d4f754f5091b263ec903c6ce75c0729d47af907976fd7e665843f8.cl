//{"err":1,"factor":2,"val":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void variable_opencl(global int* val, global int* err, int factor) {
  const int i = get_global_id(0);
  if (i > 0)
    return;

  if (*val != 42 * factor)
    *err = 1;
  else
    *val *= -1;
}