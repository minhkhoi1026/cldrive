//{"a0":0,"a1":1,"a2":2,"a3":3,"a4":4,"a5":5,"a6":6,"a7":7,"b0":8,"c0":9,"c1":10,"c2":11,"c3":12,"c4":13,"c5":14,"c6":15,"c7":16}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_block_8_1_kern(global int* a0, global int* a1, global int* a2, global int* a3, global int* a4, global int* a5, global int* a6, global int* a7, global int* b0, local int* c0, local int* c1, local int* c2, local int* c3, local int* c4, local int* c5, local int* c6, local int* c7) {
  int i;
  unsigned int gtid = get_global_id(0);
  unsigned int ltid = get_local_id(0);
  size_t lsz = get_local_size(0);
  c0[hook(9, ltid)] = a0[hook(0, gtid)] + 0;
  c1[hook(10, ltid)] = a1[hook(1, gtid)] + 1;
  c2[hook(11, ltid)] = a2[hook(2, gtid)] + 2;
  c3[hook(12, ltid)] = a3[hook(3, gtid)] + 3;
  c4[hook(13, ltid)] = a4[hook(4, gtid)] + 4;
  c5[hook(14, ltid)] = a5[hook(5, gtid)] + 5;
  c6[hook(15, ltid)] = a6[hook(6, gtid)] + 6;
  c7[hook(16, ltid)] = a7[hook(7, gtid)] + 7;
  barrier(0x01);
  int tmp0 = 0;
  int tmp1 = 0;
  int tmp2 = 0;
  int tmp3 = 0;
  int tmp4 = 0;
  int tmp5 = 0;
  int tmp6 = 0;
  int tmp7 = 0;
  for (i = 0; i < lsz; i++)
    tmp0 += c0[hook(9, i)];
  for (i = 0; i < lsz; i++)
    tmp1 += c1[hook(10, i)];
  for (i = 0; i < lsz; i++)
    tmp2 += c2[hook(11, i)];
  for (i = 0; i < lsz; i++)
    tmp3 += c3[hook(12, i)];
  for (i = 0; i < lsz; i++)
    tmp4 += c4[hook(13, i)];
  for (i = 0; i < lsz; i++)
    tmp5 += c5[hook(14, i)];
  for (i = 0; i < lsz; i++)
    tmp6 += c6[hook(15, i)];
  for (i = 0; i < lsz; i++)
    tmp7 += c7[hook(16, i)];
  tmp0 -= 5 * c0[hook(9, ltid)];
  tmp1 -= 5 * c1[hook(10, ltid)];
  tmp2 -= 5 * c2[hook(11, ltid)];
  tmp3 -= 5 * c3[hook(12, ltid)];
  tmp4 -= 5 * c4[hook(13, ltid)];
  tmp5 -= 5 * c5[hook(14, ltid)];
  tmp6 -= 5 * c6[hook(15, ltid)];
  tmp7 -= 5 * c7[hook(16, ltid)];
  b0[hook(8, gtid)] = (0 + 1) * (+tmp0 + tmp1 + tmp2 + tmp3 + tmp4 + tmp5 + tmp6 + tmp7);
}