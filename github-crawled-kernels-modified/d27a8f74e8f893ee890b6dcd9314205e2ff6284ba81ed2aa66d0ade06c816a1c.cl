//{"dst":2,"src1":0,"src2":1,"tmp":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_mixed_pointer(global unsigned int* src1, global unsigned int* src2, global unsigned int* dst) {
  int x = get_global_id(0);
  global unsigned int* tmp = ((void*)0);

  switch (x) {
    case 0:
    case 1:
    case 4:
      tmp = src1;
      break;
    default:
      tmp = src2;
      break;
  }
  dst[hook(2, x)] = tmp[hook(3, x)];
}