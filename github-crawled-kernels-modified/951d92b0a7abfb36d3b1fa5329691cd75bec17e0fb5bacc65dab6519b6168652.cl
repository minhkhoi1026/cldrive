//{"a":0,"b":1,"res":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void testFOrdGreaterThanEqual(float2 a, float2 b, global int2* res) {
  res[hook(2, 0)] = a >= b;
}