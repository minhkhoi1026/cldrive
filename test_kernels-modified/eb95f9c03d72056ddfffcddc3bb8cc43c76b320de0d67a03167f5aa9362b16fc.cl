//{"c":0,"f":6,"i":4,"result":7,"s":2,"uc":1,"ui":5,"us":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_kernel(char4 c, uchar4 uc, short4 s, ushort4 us, int4 i, uint4 ui, float4 f, global float4* result) {
  result[hook(7, 0)] = convert_float4(c);
  result[hook(7, 1)] = convert_float4(uc);
  result[hook(7, 2)] = convert_float4(s);
  result[hook(7, 3)] = convert_float4(us);
  result[hook(7, 4)] = convert_float4(i);
  result[hook(7, 5)] = convert_float4(ui);
  result[hook(7, 6)] = f;
}