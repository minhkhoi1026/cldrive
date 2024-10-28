//{"a":1,"length":0,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void tan_f64(unsigned int length, global double* a, global double* out) {
  const unsigned int id = get_global_id(0);
  if (id < length) {
    out[hook(2, id)] = tan(a[hook(1, id)]);
  }
}