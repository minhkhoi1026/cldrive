//{"out":1,"source":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_sign_extend(short2 source, global int2* out) {
  int2 x = convert_int2(source);
  out[hook(1, 0)] = x;
  out[hook(1, 1)] = x + x;
  out[hook(1, 2)] = x - x;
  out[hook(1, 3)] = x * x;
  out[hook(1, 4)] = x / (int2)100;
  out[hook(1, 5)] = x % (int2)100;
}