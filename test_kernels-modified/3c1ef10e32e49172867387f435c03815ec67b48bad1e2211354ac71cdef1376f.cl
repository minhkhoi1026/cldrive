//{"length":0,"out":1,"value":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_f64(unsigned int length, global double* out, double value) {
  const unsigned int id = get_global_id(0);
  if (id < length) {
    out[hook(1, id)] = value;
  }
}