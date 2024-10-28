//{"dst":0,"src1":1,"src2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_math_2op(global float* dst, global float* src1, global float* src2) {
  int i = get_global_id(0);
  const float x = src1[hook(1, i)], y = src2[hook(2, i)];
  float z;
  switch (i) {
    case 0:
      dst[hook(0, i)] = native_divide(x, y);
      break;
    case 1:
      dst[hook(0, i)] = fdim(x, y);
      break;
    case 2:
      dst[hook(0, i)] = fract(x, &z);
      break;
    case 3:
      dst[hook(0, i)] = hypot(x, y);
      break;
    case 4:
      dst[hook(0, i)] = ldexp(x, y);
      break;
    case 5:
      dst[hook(0, i)] = pown(x, (int)y);
      break;
    case 6:
      dst[hook(0, i)] = remainder(x, y);
      break;
    case 7:
      dst[hook(0, i)] = rootn(x, (int)(y + 1));
      break;
    case 8:
      dst[hook(0, i)] = copysign(x, y);
      break;
    case 9:
      dst[hook(0, i)] = maxmag(x, y);
      break;
    case 10:
      dst[hook(0, i)] = minmag(x, y);
      break;
    default:
      dst[hook(0, i)] = 1.f;
      break;
  };
}