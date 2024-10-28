//{"out":1,"source":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_unsign_truncate(uint2 source, global ushort2* out) {
  ushort2 x = convert_ushort2(source);
  out[hook(1, 0)] = x;
  out[hook(1, 1)] = x + x;
  out[hook(1, 2)] = x - x;
  out[hook(1, 3)] = x * x;
  out[hook(1, 4)] = x / (ushort2)100;
  out[hook(1, 5)] = x % (ushort2)100;
}