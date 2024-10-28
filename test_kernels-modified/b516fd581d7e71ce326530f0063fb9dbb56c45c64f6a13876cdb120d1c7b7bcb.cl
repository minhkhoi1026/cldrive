//{"a":0,"val":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void array_fill_f32(global float* a, float val) {
  unsigned int i = get_global_id(0);
  a[hook(0, i)] = val;
}