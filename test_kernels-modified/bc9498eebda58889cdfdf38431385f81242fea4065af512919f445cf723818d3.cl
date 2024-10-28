//{"in":1,"num":0,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_mul24(const int num, const int in, global int* out) {
  size_t offset = num * get_global_id(0);

  {
    {}
  }
  out[hook(2, offset)] = mul24(in, in);

  out[hook(2, offset + 1)] = 10 + in;
  out[hook(2, offset + 2)] = 10 - in;
}