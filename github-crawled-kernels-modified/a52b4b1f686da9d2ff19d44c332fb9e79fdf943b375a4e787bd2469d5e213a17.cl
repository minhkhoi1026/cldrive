//{"a0":0,"b0":1,"b1":2,"b2":3,"b3":4,"b4":5,"b5":6,"c0":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_block_1_6_kern(global float* a0, global float* b0, global float* b1, global float* b2, global float* b3, global float* b4, global float* b5, local float* c0) {
  int i;
  unsigned int gtid = get_global_id(0);
  unsigned int ltid = get_local_id(0);
  size_t lsz = get_local_size(0);
  c0[hook(7, ltid)] = a0[hook(0, gtid)] + 0.1f;
  barrier(0x01);
  float tmp0 = 0;
  for (i = 0; i < lsz; i++)
    tmp0 += c0[hook(7, i)];
  tmp0 -= 5 * c0[hook(7, ltid)];
  b0[hook(1, gtid)] = (0.0f + 1.1f) * (+tmp0);
  b1[hook(2, gtid)] = (1.0f + 1.1f) * (+tmp0);
  b2[hook(3, gtid)] = (2.0f + 1.1f) * (+tmp0);
  b3[hook(4, gtid)] = (3.0f + 1.1f) * (+tmp0);
  b4[hook(5, gtid)] = (4.0f + 1.1f) * (+tmp0);
  b5[hook(6, gtid)] = (5.0f + 1.1f) * (+tmp0);
}