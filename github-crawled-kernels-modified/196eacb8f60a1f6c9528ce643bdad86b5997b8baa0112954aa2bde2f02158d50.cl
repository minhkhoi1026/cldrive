//{"length":0,"out":1,"value":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_f32(unsigned int length, global float* out, float value) {
  const unsigned int id = get_global_id(0);
  if (id < length) {
    out[hook(1, id)] = value;
  }
}