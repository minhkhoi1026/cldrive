//{"arg0":0,"arg1":1,"dst":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simple_kernel_0(const unsigned int arg0, const float arg1, global unsigned int* dst) {
  unsigned int idx = get_global_id(0);
  unsigned int data = arg0 + (unsigned int)arg1;

  dst[hook(2, idx)] = data;
}