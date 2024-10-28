//{"a0":0,"b0":1,"b1":2,"c0":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_block_1_2_kern(global int* a0, global int* b0, global int* b1, local int* c0) {
  int i;
  unsigned int gtid = get_global_id(0);
  unsigned int ltid = get_local_id(0);
  size_t lsz = get_local_size(0);
  c0[hook(3, ltid)] = a0[hook(0, gtid)] + 0;
  barrier(0x01);
  int tmp0 = 0;
  for (i = 0; i < lsz; i++)
    tmp0 += c0[hook(3, i)];
  tmp0 -= 5 * c0[hook(3, ltid)];
  b0[hook(1, gtid)] = (0 + 1) * (+tmp0);
  b1[hook(2, gtid)] = (1 + 1) * (+tmp0);
}