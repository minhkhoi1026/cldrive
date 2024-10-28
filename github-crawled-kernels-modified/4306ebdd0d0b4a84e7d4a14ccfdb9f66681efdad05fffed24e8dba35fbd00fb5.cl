//{"a":1,"length":0,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void log_f32(unsigned int length, global float* a, global float* out) {
  const unsigned int id = get_global_id(0);
  if (id < length) {
    out[hook(2, id)] = log(a[hook(1, id)]);
  }
}