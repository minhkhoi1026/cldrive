//{"a0":0,"a1":1,"b0":2,"b1":3,"b2":4,"b3":5,"b4":6,"b5":7,"c0":8,"c1":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_block_2_6_kern(global int* a0, global int* a1, global int* b0, global int* b1, global int* b2, global int* b3, global int* b4, global int* b5, local int* c0, local int* c1) {
  int i;
  unsigned int gtid = get_global_id(0);
  unsigned int ltid = get_local_id(0);
  size_t lsz = get_local_size(0);
  c0[hook(8, ltid)] = a0[hook(0, gtid)] + 0;
  c1[hook(9, ltid)] = a1[hook(1, gtid)] + 1;
  barrier(0x01);
  int tmp0 = 0;
  int tmp1 = 0;
  for (i = 0; i < lsz; i++)
    tmp0 += c0[hook(8, i)];
  for (i = 0; i < lsz; i++)
    tmp1 += c1[hook(9, i)];
  tmp0 -= 5 * c0[hook(8, ltid)];
  tmp1 -= 5 * c1[hook(9, ltid)];
  b0[hook(2, gtid)] = (0 + 1) * (+tmp0 + tmp1);
  b1[hook(3, gtid)] = (1 + 1) * (+tmp0 + tmp1);
  b2[hook(4, gtid)] = (2 + 1) * (+tmp0 + tmp1);
  b3[hook(5, gtid)] = (3 + 1) * (+tmp0 + tmp1);
  b4[hook(6, gtid)] = (4 + 1) * (+tmp0 + tmp1);
  b5[hook(7, gtid)] = (5 + 1) * (+tmp0 + tmp1);
}