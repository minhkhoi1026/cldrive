//{"a0":0,"a1":1,"a2":2,"b0":3,"b1":4,"b2":5,"b3":6,"b4":7,"b5":8,"c0":9,"c1":10,"c2":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_block_3_6_kern(global int* a0, global int* a1, global int* a2, global int* b0, global int* b1, global int* b2, global int* b3, global int* b4, global int* b5, local int* c0, local int* c1, local int* c2) {
  int i;
  unsigned int gtid = get_global_id(0);
  unsigned int ltid = get_local_id(0);
  size_t lsz = get_local_size(0);
  c0[hook(9, ltid)] = a0[hook(0, gtid)] + 0;
  c1[hook(10, ltid)] = a1[hook(1, gtid)] + 1;
  c2[hook(11, ltid)] = a2[hook(2, gtid)] + 2;
  barrier(0x01);
  int tmp0 = 0;
  int tmp1 = 0;
  int tmp2 = 0;
  for (i = 0; i < lsz; i++)
    tmp0 += c0[hook(9, i)];
  for (i = 0; i < lsz; i++)
    tmp1 += c1[hook(10, i)];
  for (i = 0; i < lsz; i++)
    tmp2 += c2[hook(11, i)];
  tmp0 -= 5 * c0[hook(9, ltid)];
  tmp1 -= 5 * c1[hook(10, ltid)];
  tmp2 -= 5 * c2[hook(11, ltid)];
  b0[hook(3, gtid)] = (0 + 1) * (+tmp0 + tmp1 + tmp2);
  b1[hook(4, gtid)] = (1 + 1) * (+tmp0 + tmp1 + tmp2);
  b2[hook(5, gtid)] = (2 + 1) * (+tmp0 + tmp1 + tmp2);
  b3[hook(6, gtid)] = (3 + 1) * (+tmp0 + tmp1 + tmp2);
  b4[hook(7, gtid)] = (4 + 1) * (+tmp0 + tmp1 + tmp2);
  b5[hook(8, gtid)] = (5 + 1) * (+tmp0 + tmp1 + tmp2);
}