//{"a0":0,"b0":1,"c0":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_block_1_1_kern(global float* a0, global float* b0, local float* c0) {
  int i;
  unsigned int gtid = get_global_id(0);
  unsigned int ltid = get_local_id(0);
  size_t lsz = get_local_size(0);
  c0[hook(2, ltid)] = a0[hook(0, gtid)] + 0.1f;
  barrier(0x01);
  float tmp0 = 0;
  for (i = 0; i < lsz; i++)
    tmp0 += c0[hook(2, i)];
  tmp0 -= 5 * c0[hook(2, ltid)];
  b0[hook(1, gtid)] = (0.0f + 1.1f) * (+tmp0);
}