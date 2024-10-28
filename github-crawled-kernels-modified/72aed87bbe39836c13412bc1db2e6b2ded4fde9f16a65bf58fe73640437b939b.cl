//{"f0":2,"f1":3,"floatOut":5,"i0":0,"i1":1,"intOut":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_instructions(const int i0, const int i1, const float f0, const float f1, global int* intOut, global float* floatOut) {
  intOut[hook(4, 0)] = i0 + i1;
  intOut[hook(4, 1)] = i0 - i1;
  intOut[hook(4, 2)] = i0 * i1;
  intOut[hook(4, 3)] = i0 / i1;
  intOut[hook(4, 4)] = i0 % i1;
  intOut[hook(4, 5)] = max(i0, i1);
  intOut[hook(4, 6)] = min(i0, i1);
  intOut[hook(4, 7)] = (int)f0;
  intOut[hook(4, 8)] = i0 << i1;
  intOut[hook(4, 9)] = i0 >> i1;
  intOut[hook(4, 10)] = i0 & i1;
  intOut[hook(4, 11)] = i0 | i1;
  intOut[hook(4, 12)] = i0 ^ i1;
  intOut[hook(4, 13)] = ~i0;
  intOut[hook(4, 14)] = clz(i0);
  int j = i0;
  intOut[hook(4, 15)] = ++j;
  intOut[hook(4, 16)] = j--;
  intOut[hook(4, 17)] = i0 < i1;
  intOut[hook(4, 18)] = i0 <= i1;
  intOut[hook(4, 19)] = i0 == i1;
  intOut[hook(4, 20)] = i0 >= i1;
  intOut[hook(4, 21)] = i0 > i1;
  intOut[hook(4, 22)] = i0 != i1;
  intOut[hook(4, 23)] = i0 && i1;
  intOut[hook(4, 24)] = i0 || i1;
  intOut[hook(4, 25)] = !i0;
  intOut[hook(4, 26)] = sizeof(i0);
  intOut[hook(4, 27)] = ((char)i0) * ((char)i1);
  floatOut[hook(5, 0)] = f0 + f1;
  floatOut[hook(5, 1)] = f0 - f1;
  floatOut[hook(5, 2)] = f0 * f1;
  floatOut[hook(5, 3)] = f0 / f1;
  floatOut[hook(5, 4)] = max(f0, f1);
  floatOut[hook(5, 5)] = min(f0, f1);
  floatOut[hook(5, 6)] = (float)i0;
}