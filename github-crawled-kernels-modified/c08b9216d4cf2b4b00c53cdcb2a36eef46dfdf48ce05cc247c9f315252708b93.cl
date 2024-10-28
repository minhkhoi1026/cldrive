//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_float3(global float* pin, global float* pout) {
  int x = get_global_id(0);
  float3 value;
  value = vload3(x, pin);
  value += (float3){(float)1, (float)2, (float)3};
  vstore3(value, x, pout);
}