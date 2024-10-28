//{"dst":1,"p":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_pointer_cast(global unsigned char* src, global unsigned int* dst) {
  int tid = get_global_id(0);
  global unsigned int* p = (global unsigned int*)src;

  dst[hook(1, tid)] = p[hook(2, tid)];
}