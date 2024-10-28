//{"data":0,"increments":1,"len":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void es_phase_3(global unsigned int* restrict data, global unsigned int* restrict increments, unsigned int len) {
  const unsigned int thread = get_local_id(0);
  const unsigned int block = get_group_id(0);
  const unsigned int threads_per_block = get_local_size(0);
  const unsigned int elements_per_block = threads_per_block * 2;
  const unsigned int global_offset = block * elements_per_block;

  unsigned int ai = 2 * thread;
  unsigned int bi = 2 * thread + 1;
  unsigned int ai_global = ai + global_offset;
  unsigned int bi_global = bi + global_offset;
  unsigned int increment = increments[hook(1, block)];
  if (ai_global < len)
    data[hook(0, ai_global)] += increment;
  if (bi_global < len)
    data[hook(0, bi_global)] += increment;
}