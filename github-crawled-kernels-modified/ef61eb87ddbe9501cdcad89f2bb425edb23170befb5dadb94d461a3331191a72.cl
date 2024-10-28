//{"length":0,"out":1,"start":2,"step":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void linspace_f32(unsigned int length, global float* out, float start, float step) {
  const unsigned int id = get_global_id(0);
  if (id < length) {
    out[hook(1, id)] = start + step * ((float)id);
  }
}