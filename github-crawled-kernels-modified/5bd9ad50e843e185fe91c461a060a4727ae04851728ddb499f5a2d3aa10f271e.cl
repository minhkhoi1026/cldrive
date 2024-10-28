//{"a":1,"b":2,"length":0,"out":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mul_f32(unsigned int length, global float* a, global float* b, global float* out) {
  const unsigned int id = get_global_id(0);
  if (id < length) {
    out[hook(3, id)] = a[hook(1, id)] * b[hook(2, id)];
  }
}