//{"a0":0,"a1":1,"a2":2,"a3":3,"b0":4,"b1":5,"b2":6,"b3":7,"b4":8,"c0":9,"c1":10,"c2":11,"c3":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_block_4_5_kern(global int* a0, global int* a1, global int* a2, global int* a3, global int* b0, global int* b1, global int* b2, global int* b3, global int* b4, local int* c0, local int* c1, local int* c2, local int* c3) {
  int i;
  unsigned int gtid = get_global_id(0);
  unsigned int ltid = get_local_id(0);
  size_t lsz = get_local_size(0);
  c0[hook(9, ltid)] = a0[hook(0, gtid)] + 0;
  c1[hook(10, ltid)] = a1[hook(1, gtid)] + 1;
  c2[hook(11, ltid)] = a2[hook(2, gtid)] + 2;
  c3[hook(12, ltid)] = a3[hook(3, gtid)] + 3;
  barrier(0x01);
  int tmp0 = 0;
  int tmp1 = 0;
  int tmp2 = 0;
  int tmp3 = 0;
  for (i = 0; i < lsz; i++)
    tmp0 += c0[hook(9, i)];
  for (i = 0; i < lsz; i++)
    tmp1 += c1[hook(10, i)];
  for (i = 0; i < lsz; i++)
    tmp2 += c2[hook(11, i)];
  for (i = 0; i < lsz; i++)
    tmp3 += c3[hook(12, i)];
  tmp0 -= 5 * c0[hook(9, ltid)];
  tmp1 -= 5 * c1[hook(10, ltid)];
  tmp2 -= 5 * c2[hook(11, ltid)];
  tmp3 -= 5 * c3[hook(12, ltid)];
  b0[hook(4, gtid)] = (0 + 1) * (+tmp0 + tmp1 + tmp2 + tmp3);
  b1[hook(5, gtid)] = (1 + 1) * (+tmp0 + tmp1 + tmp2 + tmp3);
  b2[hook(6, gtid)] = (2 + 1) * (+tmp0 + tmp1 + tmp2 + tmp3);
  b3[hook(7, gtid)] = (3 + 1) * (+tmp0 + tmp1 + tmp2 + tmp3);
  b4[hook(8, gtid)] = (4 + 1) * (+tmp0 + tmp1 + tmp2 + tmp3);
}