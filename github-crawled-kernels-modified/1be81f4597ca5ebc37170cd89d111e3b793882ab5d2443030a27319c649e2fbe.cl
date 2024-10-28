//{"a0":0,"a1":1,"b0":2,"b1":3,"b2":4,"b3":5,"c0":6,"c1":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_block_2_4_kern(global float* a0, global float* a1, global float* b0, global float* b1, global float* b2, global float* b3, local float* c0, local float* c1) {
  int i;
  unsigned int gtid = get_global_id(0);
  unsigned int ltid = get_local_id(0);
  size_t lsz = get_local_size(0);
  c0[hook(6, ltid)] = a0[hook(0, gtid)] + 0.1f;
  c1[hook(7, ltid)] = a1[hook(1, gtid)] + 1.1f;
  barrier(0x01);
  float tmp0 = 0;
  float tmp1 = 0;
  for (i = 0; i < lsz; i++)
    tmp0 += c0[hook(6, i)];
  for (i = 0; i < lsz; i++)
    tmp1 += c1[hook(7, i)];
  tmp0 -= 5 * c0[hook(6, ltid)];
  tmp1 -= 5 * c1[hook(7, ltid)];
  b0[hook(2, gtid)] = (0.0f + 1.1f) * (+tmp0 + tmp1);
  b1[hook(3, gtid)] = (1.0f + 1.1f) * (+tmp0 + tmp1);
  b2[hook(4, gtid)] = (2.0f + 1.1f) * (+tmp0 + tmp1);
  b3[hook(5, gtid)] = (3.0f + 1.1f) * (+tmp0 + tmp1);
}