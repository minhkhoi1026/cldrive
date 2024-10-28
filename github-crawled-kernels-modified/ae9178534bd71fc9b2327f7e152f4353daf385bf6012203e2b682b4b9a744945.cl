//{"buf":0,"num_groups":1,"result":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void sum_histogram(global unsigned int* buf, int num_groups, global unsigned int* result) {
  int idx = get_global_id(0) + get_group_id(0);
  unsigned int v = 0;
  int group_offset = 0, n = num_groups;
  while (--n >= 0) {
    v += buf[hook(0, group_offset + idx)];
    group_offset += 256;
  }
  result[hook(2, idx)] = v;
}