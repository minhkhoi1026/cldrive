//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_float2(global float* pin, global float* pout) {
  int x = get_global_id(0);
  float2 value;
  value = vload2(x, pin);
  value += (float2){(float)1, (float)2};
  vstore2(value, x, pout);
}