//{"img":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int test_const_attr(int a) {
  return max(a, 2);
}

kernel void test_pure_attr(read_only image1d_t img) {
  float4 resf = read_imagef(img, 42);
}