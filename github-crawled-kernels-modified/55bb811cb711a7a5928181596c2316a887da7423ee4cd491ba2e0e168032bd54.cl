//{"in":1,"num":0,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_sqrt(const int num, global const float* in, global float* out) {
  int offset = num * get_global_id(0);
  for (int i = 0; i < num; ++i) {
    out[hook(2, offset + i)] = sqrt(in[hook(1, i)]);
  }
}