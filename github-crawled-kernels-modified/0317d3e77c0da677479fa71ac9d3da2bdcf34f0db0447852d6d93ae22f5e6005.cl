//{"out":1,"source":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_unsign_extend(ushort2 source, global uint2* out) {
  uint2 x = convert_uint2(source);
  out[hook(1, 0)] = x;
  out[hook(1, 1)] = x + x;
  out[hook(1, 2)] = x - x;
  out[hook(1, 3)] = x * x;
  out[hook(1, 4)] = x / (uint2)100;
  out[hook(1, 5)] = x % (uint2)100;
}