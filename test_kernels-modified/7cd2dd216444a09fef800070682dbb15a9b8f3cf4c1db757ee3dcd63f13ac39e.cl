//{"dst":3,"dst4":1,"offset":2,"src":4,"src4":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_array4(global int4* src4, global int4* dst4, int offset) {
  int i;
  int final[16];
  global int* dst = (global int*)(dst4 + offset + get_global_id(0));
  global int* src = (global int*)(src4 + offset + get_global_id(0));
  dst[hook(3, -4)] = src[hook(4, -4)];
}