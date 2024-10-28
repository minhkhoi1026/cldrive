//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void super_decode(global char* in, global char* out) {
  int num = get_global_id(0);
  out[hook(1, num)] = in[hook(0, num)] + 2;
}