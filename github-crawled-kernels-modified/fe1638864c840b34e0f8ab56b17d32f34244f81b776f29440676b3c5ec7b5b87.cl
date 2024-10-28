//{"_buf0":5,"_buf1":6,"block_size":2,"block_sums":0,"count":3,"init":4,"scratch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void local_scan(global unsigned int* block_sums, local unsigned int* scratch, const unsigned int block_size, const unsigned int count, const unsigned int init, global unsigned int* _buf0, global unsigned int* _buf1) {
  const unsigned int gid = get_global_id(0);
  const unsigned int lid = get_local_id(0);
  if (gid < count) {
    const unsigned int local_init = (gid == 0) ? init : 0;
    if (lid == 0) {
      scratch[hook(1, lid)] = local_init;
    } else {
      scratch[hook(1, lid)] = _buf0[hook(5, gid - 1)];
    }
  } else {
    scratch[hook(1, lid)] = 0;
  }
  barrier(0x01);
  for (unsigned int i = 1; i < block_size; i <<= 1) {
    const unsigned int x = lid >= i ? scratch[hook(1, lid - i)] : 0;
    barrier(0x01);
    if (lid >= i) {
      scratch[hook(1, lid)] = ((scratch[hook(1, lid)]) + (x));
    }
    barrier(0x01);
  }
  if (gid < count) {
    _buf1[hook(6, gid)] = scratch[hook(1, lid)];
  }
  if (lid == block_size - 1) {
    block_sums[hook(0, get_group_id(0))] = ((_buf0[hook(5, gid)]) + (scratch[hook(1, lid)]));
  }
}