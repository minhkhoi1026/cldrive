//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void postdec(global unsigned int* out, unsigned int in) {
  out[hook(0, 0)] = in--;
}