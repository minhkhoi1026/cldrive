//{"in":0,"mask":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_shuffle_upcast(const global char8* in, const global uchar8* mask, global char8* out) {
  char8 result = (char8)0x17;

  result.s4 = shuffle(in[hook(0, 0)], mask[hook(1, 0)]).s6;

  out[hook(2, 0)] = result;

  result = (char8)0x42;

  result.s37 = shuffle(in[hook(0, 1)], mask[hook(1, 1)]).s05;

  out[hook(2, 1)] = result;

  result = (char8)0x13;

  result.s052 = shuffle(in[hook(0, 2)], mask[hook(1, 2)]).s376;

  out[hook(2, 2)] = result;

  result = (char8)0xFF;

  result.s3147 = shuffle(in[hook(0, 3)], mask[hook(1, 3)]).s2157;

  out[hook(2, 3)] = result;

  result = (char8)0x71;

  result.s0123 = shuffle(in[hook(0, 4)], mask[hook(1, 4)]).s2157;

  out[hook(2, 4)] = result;

  result = (char8)0x31;

  result.s0 = shuffle(in[hook(0, 5)], mask[hook(1, 5)]).s7;

  out[hook(2, 5)] = result;
}