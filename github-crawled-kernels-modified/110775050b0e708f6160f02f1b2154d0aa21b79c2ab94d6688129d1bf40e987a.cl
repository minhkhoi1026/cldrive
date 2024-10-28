//{"M":0,"V":1,"dst":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((intel_reqd_sub_group_size(16))) kernel void test_kernel(const global unsigned int* M, const global unsigned int* V, global unsigned int* dst) {
  const int x = get_global_id(0);
  const int wind = get_global_size(0);

  dst[hook(2, x)] = 0;
  for (int i = 0; i < wind; ++i) {
    dst[hook(2, x)] += M[hook(0, x * wind + i)] * V[hook(1, i)];
  }
}