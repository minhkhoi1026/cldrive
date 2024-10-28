//{"a":1,"b":2,"length":0,"out":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void divrc_f32(unsigned int length, global float* a, float b, global float* out) {
  const unsigned int id = get_global_id(0);
  if (id < length) {
    out[hook(3, id)] = b / a[hook(1, id)];
  }
}