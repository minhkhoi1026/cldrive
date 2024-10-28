//{"dst":0,"src1":1,"src2":2,"src3":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_math_3op_float(global float* dst, global float* src1, global float* src2, global float* src3) {
  int i = get_global_id(0);
  const float x = src1[hook(1, i)], y = src2[hook(2, i)], z = src3[hook(3, i)];
  switch (i % 2) {
    case 0:
      dst[hook(0, i)] = mad(x, y, z);
      break;
    case 1:
      dst[hook(0, i)] = fma(x, y, z);
      break;
    default:
      dst[hook(0, i)] = 1.f;
      break;
  };
  dst[hook(0, 0)] = mad(src1[hook(1, 0)], src2[hook(2, 0)], src3[hook(3, 0)]);
}