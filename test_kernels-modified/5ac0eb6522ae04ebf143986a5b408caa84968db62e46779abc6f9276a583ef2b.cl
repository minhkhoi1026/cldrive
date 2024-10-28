//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void testuchars(global unsigned char* in, global unsigned char* out) {
  const int globalid = get_global_id(0);
  out[hook(1, globalid)] = in[hook(0, globalid)] + 7;
}