//{"lhs":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef unsigned char __attribute__((ext_vector_type(3))) uchar3;
kernel void test_odd_vector2(uchar3 lhs) {
  lhs.hi = 2;
}