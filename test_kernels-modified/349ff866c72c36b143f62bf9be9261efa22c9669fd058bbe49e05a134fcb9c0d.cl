//{"a0":0,"a1":1,"a2":2,"a3":3,"a4":4,"a5":5,"b0":6,"c0":7,"c1":8,"c2":9,"c3":10,"c4":11,"c5":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_block_6_1_kern(global float* a0, global float* a1, global float* a2, global float* a3, global float* a4, global float* a5, global float* b0, local float* c0, local float* c1, local float* c2, local float* c3, local float* c4, local float* c5) {
  int i;
  unsigned int gtid = get_global_id(0);
  unsigned int ltid = get_local_id(0);
  size_t lsz = get_local_size(0);
  c0[hook(7, ltid)] = a0[hook(0, gtid)] + 0.1f;
  c1[hook(8, ltid)] = a1[hook(1, gtid)] + 1.1f;
  c2[hook(9, ltid)] = a2[hook(2, gtid)] + 2.1f;
  c3[hook(10, ltid)] = a3[hook(3, gtid)] + 3.1f;
  c4[hook(11, ltid)] = a4[hook(4, gtid)] + 4.1f;
  c5[hook(12, ltid)] = a5[hook(5, gtid)] + 5.1f;
  barrier(0x01);
  float tmp0 = 0;
  float tmp1 = 0;
  float tmp2 = 0;
  float tmp3 = 0;
  float tmp4 = 0;
  float tmp5 = 0;
  for (i = 0; i < lsz; i++)
    tmp0 += c0[hook(7, i)];
  for (i = 0; i < lsz; i++)
    tmp1 += c1[hook(8, i)];
  for (i = 0; i < lsz; i++)
    tmp2 += c2[hook(9, i)];
  for (i = 0; i < lsz; i++)
    tmp3 += c3[hook(10, i)];
  for (i = 0; i < lsz; i++)
    tmp4 += c4[hook(11, i)];
  for (i = 0; i < lsz; i++)
    tmp5 += c5[hook(12, i)];
  tmp0 -= 5 * c0[hook(7, ltid)];
  tmp1 -= 5 * c1[hook(8, ltid)];
  tmp2 -= 5 * c2[hook(9, ltid)];
  tmp3 -= 5 * c3[hook(10, ltid)];
  tmp4 -= 5 * c4[hook(11, ltid)];
  tmp5 -= 5 * c5[hook(12, ltid)];
  b0[hook(6, gtid)] = (0.0f + 1.1f) * (+tmp0 + tmp1 + tmp2 + tmp3 + tmp4 + tmp5);
}