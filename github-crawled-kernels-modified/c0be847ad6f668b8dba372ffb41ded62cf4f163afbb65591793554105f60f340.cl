//{"a0":0,"a1":1,"a2":2,"a3":3,"a4":4,"a5":5,"a6":6,"b0":7,"c0":8,"c1":9,"c2":10,"c3":11,"c4":12,"c5":13,"c6":14}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_block_7_1_kern(global float* a0, global float* a1, global float* a2, global float* a3, global float* a4, global float* a5, global float* a6, global float* b0, local float* c0, local float* c1, local float* c2, local float* c3, local float* c4, local float* c5, local float* c6) {
  int i;
  unsigned int gtid = get_global_id(0);
  unsigned int ltid = get_local_id(0);
  size_t lsz = get_local_size(0);
  c0[hook(8, ltid)] = a0[hook(0, gtid)] + 0.1f;
  c1[hook(9, ltid)] = a1[hook(1, gtid)] + 1.1f;
  c2[hook(10, ltid)] = a2[hook(2, gtid)] + 2.1f;
  c3[hook(11, ltid)] = a3[hook(3, gtid)] + 3.1f;
  c4[hook(12, ltid)] = a4[hook(4, gtid)] + 4.1f;
  c5[hook(13, ltid)] = a5[hook(5, gtid)] + 5.1f;
  c6[hook(14, ltid)] = a6[hook(6, gtid)] + 6.1f;
  barrier(0x01);
  float tmp0 = 0;
  float tmp1 = 0;
  float tmp2 = 0;
  float tmp3 = 0;
  float tmp4 = 0;
  float tmp5 = 0;
  float tmp6 = 0;
  for (i = 0; i < lsz; i++)
    tmp0 += c0[hook(8, i)];
  for (i = 0; i < lsz; i++)
    tmp1 += c1[hook(9, i)];
  for (i = 0; i < lsz; i++)
    tmp2 += c2[hook(10, i)];
  for (i = 0; i < lsz; i++)
    tmp3 += c3[hook(11, i)];
  for (i = 0; i < lsz; i++)
    tmp4 += c4[hook(12, i)];
  for (i = 0; i < lsz; i++)
    tmp5 += c5[hook(13, i)];
  for (i = 0; i < lsz; i++)
    tmp6 += c6[hook(14, i)];
  tmp0 -= 5 * c0[hook(8, ltid)];
  tmp1 -= 5 * c1[hook(9, ltid)];
  tmp2 -= 5 * c2[hook(10, ltid)];
  tmp3 -= 5 * c3[hook(11, ltid)];
  tmp4 -= 5 * c4[hook(12, ltid)];
  tmp5 -= 5 * c5[hook(13, ltid)];
  tmp6 -= 5 * c6[hook(14, ltid)];
  b0[hook(7, gtid)] = (0.0f + 1.1f) * (+tmp0 + tmp1 + tmp2 + tmp3 + tmp4 + tmp5 + tmp6);
}