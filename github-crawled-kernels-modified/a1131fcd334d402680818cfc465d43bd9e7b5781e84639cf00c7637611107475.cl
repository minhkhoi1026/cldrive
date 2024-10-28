//{"a0":0,"a1":1,"a2":2,"a3":3,"b0":4,"b1":5,"b2":6,"b3":7,"c0":8,"c1":9,"c2":10,"c3":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_block_4_4_kern(global float* a0, global float* a1, global float* a2, global float* a3, global float* b0, global float* b1, global float* b2, global float* b3, local float* c0, local float* c1, local float* c2, local float* c3) {
  int i;
  unsigned int gtid = get_global_id(0);
  unsigned int ltid = get_local_id(0);
  size_t lsz = get_local_size(0);
  c0[hook(8, ltid)] = a0[hook(0, gtid)] + 0.1f;
  c1[hook(9, ltid)] = a1[hook(1, gtid)] + 1.1f;
  c2[hook(10, ltid)] = a2[hook(2, gtid)] + 2.1f;
  c3[hook(11, ltid)] = a3[hook(3, gtid)] + 3.1f;
  barrier(0x01);
  float tmp0 = 0;
  float tmp1 = 0;
  float tmp2 = 0;
  float tmp3 = 0;
  for (i = 0; i < lsz; i++)
    tmp0 += c0[hook(8, i)];
  for (i = 0; i < lsz; i++)
    tmp1 += c1[hook(9, i)];
  for (i = 0; i < lsz; i++)
    tmp2 += c2[hook(10, i)];
  for (i = 0; i < lsz; i++)
    tmp3 += c3[hook(11, i)];
  tmp0 -= 5 * c0[hook(8, ltid)];
  tmp1 -= 5 * c1[hook(9, ltid)];
  tmp2 -= 5 * c2[hook(10, ltid)];
  tmp3 -= 5 * c3[hook(11, ltid)];
  b0[hook(4, gtid)] = (0.0f + 1.1f) * (+tmp0 + tmp1 + tmp2 + tmp3);
  b1[hook(5, gtid)] = (1.0f + 1.1f) * (+tmp0 + tmp1 + tmp2 + tmp3);
  b2[hook(6, gtid)] = (2.0f + 1.1f) * (+tmp0 + tmp1 + tmp2 + tmp3);
  b3[hook(7, gtid)] = (3.0f + 1.1f) * (+tmp0 + tmp1 + tmp2 + tmp3);
}