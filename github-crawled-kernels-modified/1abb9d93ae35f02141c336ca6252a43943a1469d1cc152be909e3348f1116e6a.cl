//{"a0":0,"a1":1,"a2":2,"a3":3,"b0":4,"c0":5,"c1":6,"c2":7,"c3":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_block_4_1_kern(global int* a0, global int* a1, global int* a2, global int* a3, global int* b0, local int* c0, local int* c1, local int* c2, local int* c3) {
  int i;
  unsigned int gtid = get_global_id(0);
  unsigned int ltid = get_local_id(0);
  size_t lsz = get_local_size(0);
  c0[hook(5, ltid)] = a0[hook(0, gtid)] + 0;
  c1[hook(6, ltid)] = a1[hook(1, gtid)] + 1;
  c2[hook(7, ltid)] = a2[hook(2, gtid)] + 2;
  c3[hook(8, ltid)] = a3[hook(3, gtid)] + 3;
  barrier(0x01);
  int tmp0 = 0;
  int tmp1 = 0;
  int tmp2 = 0;
  int tmp3 = 0;
  for (i = 0; i < lsz; i++)
    tmp0 += c0[hook(5, i)];
  for (i = 0; i < lsz; i++)
    tmp1 += c1[hook(6, i)];
  for (i = 0; i < lsz; i++)
    tmp2 += c2[hook(7, i)];
  for (i = 0; i < lsz; i++)
    tmp3 += c3[hook(8, i)];
  tmp0 -= 5 * c0[hook(5, ltid)];
  tmp1 -= 5 * c1[hook(6, ltid)];
  tmp2 -= 5 * c2[hook(7, ltid)];
  tmp3 -= 5 * c3[hook(8, ltid)];
  b0[hook(4, gtid)] = (0 + 1) * (+tmp0 + tmp1 + tmp2 + tmp3);
}