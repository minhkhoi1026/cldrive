//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_float4(global float* pin, global float* pout) {
  int x = get_global_id(0);
  float4 value;
  value = vload4(x, pin);
  value += (float4){(float)1, (float)2, (float)3, (float)4};
  vstore4(value, x, pout);
}