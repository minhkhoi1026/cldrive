//{"dst":0,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_math(global float* dst, global float* src) {
  int i = get_global_id(0);
  const float x = src[hook(1, i)];
  switch (i) {
    case 0:
      dst[hook(0, i)] = cos(x);
      break;
    case 1:
      dst[hook(0, i)] = sin(x);
      break;
    case 2:
      dst[hook(0, i)] = log2(x);
      break;
    case 3:
      dst[hook(0, i)] = sqrt(x);
      break;
    case 4:
      dst[hook(0, i)] = rsqrt(x);
      break;
    case 5:
      dst[hook(0, i)] = native_recip(x);
      break;
    case 6:
      dst[hook(0, i)] = tan(x);
      break;
    case 7:
      dst[hook(0, i)] = cbrt(x);
      break;
    case 8:
      dst[hook(0, i)] = ceil(x);
      break;
    case 9:
      dst[hook(0, i)] = cospi(x);
      break;
    case 10:
      dst[hook(0, i)] = exp2(x);
      break;
    case 11:
      dst[hook(0, i)] = exp10(x);
      break;
    case 12:
      dst[hook(0, i)] = expm1(x);
      break;
    case 13:
      dst[hook(0, i)] = log1p(x);
      break;
    case 14:
      dst[hook(0, i)] = logb(x);
      break;
    case 15:
      dst[hook(0, i)] = sinpi(x);
      break;
    case 16:
      dst[hook(0, i)] = tanpi(x);
      break;
    case 17:
      dst[hook(0, i)] = rint(x);
      break;
    case 18:
      dst[hook(0, i)] = sinh(x);
      break;
    case 19:
      dst[hook(0, i)] = cosh(x);
      break;
    case 20:
      dst[hook(0, i)] = tanh(x);
      break;
    case 21:
      dst[hook(0, i)] = asinh(x);
      break;
    case 22:
      dst[hook(0, i)] = acosh(x);
      break;
    case 23:
      dst[hook(0, i)] = atanh(x);
      break;
    case 24:
      dst[hook(0, i)] = asin(x);
      break;
    case 25:
      dst[hook(0, i)] = acos(x);
      break;
    case 26:
      dst[hook(0, i)] = atan(x);
      break;
    case 27:
      dst[hook(0, i)] = asinpi(x);
      break;
    case 28:
      dst[hook(0, i)] = acospi(x);
      break;
    case 29:
      dst[hook(0, i)] = atanpi(x);
      break;
    case 30:
      dst[hook(0, i)] = erf(x);
      break;
    case 31:
      dst[hook(0, i)] = nan((unsigned int)x);
      break;
    default:
      dst[hook(0, i)] = 1.f;
      break;
  };
}