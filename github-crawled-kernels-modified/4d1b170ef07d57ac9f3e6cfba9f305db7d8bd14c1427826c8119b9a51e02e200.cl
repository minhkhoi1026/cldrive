//{"dst":1,"num0":2,"num1":3,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_long_mul_hi(global long* src, global long* dst, long num0, long num1) {
  int i = get_local_id(0);
  long c;

  if (i % 2 == 0) {
    c = mul_hi(src[hook(0, i)], num0);
  } else {
    c = mul_hi(src[hook(0, i)], num1);
  }
  dst[hook(1, i)] = c;
}