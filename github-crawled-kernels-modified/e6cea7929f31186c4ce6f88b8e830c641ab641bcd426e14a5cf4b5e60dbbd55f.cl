//{"Nx":1,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_char(global uchar* output, unsigned int Nx) {
  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);

  output[hook(0, i + Nx * j)] = (uchar)(128);
}