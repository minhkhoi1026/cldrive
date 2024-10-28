//{"_buf0":3,"_buf1":4,"_buf2":5,"block":1,"block_idx":2,"count":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void find_extrema_reduce_min(unsigned int count, local int* block, local unsigned int* block_idx, global unsigned int* _buf0, global int* _buf1, global int* _buf2) {
  const unsigned int gid = get_global_id(0);
  unsigned int idx = gid;
  int acc;
  unsigned int acc_idx;
  if (gid < count) {
    acc_idx = idx;

    acc = _buf1[hook(4, idx)];
    idx += get_global_size(0);
  }
  bool compare_result;
  bool equal;
  while (idx < count) {
    int next = _buf1[hook(4, idx)];
    compare_result = ((acc) < (next));

    acc = compare_result ? acc : next;

    acc_idx = compare_result ? acc_idx : idx;

    idx += get_global_size(0);
  }
  const unsigned int lid = get_local_id(0);
  block[hook(1, lid)] = acc;
  block_idx[hook(2, lid)] = acc_idx;
  barrier(0x01);
  unsigned int group_offset = count - (get_local_size(0) * get_group_id(0));
  for (unsigned int offset = 12 / 2; offset > 0; offset = offset / 2) {
    if ((lid < offset) && ((lid + offset) < group_offset)) {
      int mine = block[hook(1, lid)];
      int other = block[hook(1, lid + offset)];

      compare_result = ((mine) < (other));
      equal = !compare_result && !((other) < (mine));

      block[hook(1, lid)] = compare_result ? mine : other;
      unsigned int mine_idx = block_idx[hook(2, lid)];
      unsigned int other_idx = block_idx[hook(2, lid + offset)];
      block_idx[hook(2, lid)] = compare_result ? mine_idx : (equal ? min(mine_idx, other_idx) : other_idx);
    }
    barrier(0x01);
  }
  if (lid == 0) {
    _buf2[hook(5, get_group_id(0))] = block[hook(1, 0)];
    _buf0[hook(3, get_group_id(0))] = block_idx[hook(2, 0)];
  }
}