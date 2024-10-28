//{"dst":2,"src1":0,"src2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int comp_long(long x, long y);
inline int greater(long x, long y) {
  return x > y;
}

int comp_long(long x, long y) {
  return x < y;
}

kernel void runtime_compile_link_a(global long* src1, global long* src2, global long* dst) {
  int i = get_global_id(0);
  int j = comp_long(src1[hook(0, i)], src2[hook(1, i)]);
  dst[hook(2, i)] = j ? 3 : 4;
}