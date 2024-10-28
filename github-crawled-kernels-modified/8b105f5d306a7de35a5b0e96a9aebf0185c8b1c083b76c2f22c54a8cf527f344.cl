//{"f":0,"t":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void array_copy_to_f32(global const float* f, global float* t) {
  unsigned int i = get_global_id(0);
  t[hook(1, i)] = f[hook(0, i)];
}