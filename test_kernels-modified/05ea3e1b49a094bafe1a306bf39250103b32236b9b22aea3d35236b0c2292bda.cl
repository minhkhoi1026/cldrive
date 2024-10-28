//{"(*A)":3,"(*B)":5,"(*C)":6,"borrow":4,"dst":2,"src0":0,"src1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_overflow_uint4_sub(global uint4* src0, global uint4* src1, global uint4* dst) {
  global uint4* A = &src0[hook(0, get_global_id(0))];
  global uint4* B = &src1[hook(1, get_global_id(0))];
  global uint4* C = &dst[hook(2, get_global_id(0))];
  uint4 borrow;
  unsigned result;
  size_t num = sizeof(*A) / sizeof((*A)[hook(3, 0)]);
  for (unsigned int i = 0; i < num; i++) {
    borrow[hook(4, i)] = __builtin_usub_overflow((*A)[hook(3, i)], (*B)[hook(5, i)], &result);
    (*C)[hook(6, i)] = result;
  }
  for (unsigned int i = 0; i < num - 1; i++) {
    borrow[hook(4, i + 1)] += (*C)[hook(6, i + 1)] < borrow[hook(4, i)];
    (*C)[hook(6, i + 1)] -= borrow[hook(4, i)];
  }
}