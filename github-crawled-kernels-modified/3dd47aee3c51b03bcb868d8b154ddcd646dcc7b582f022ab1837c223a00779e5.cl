//{"res":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void block_fn(size_t tid, int mul, global int* res) {
  res[hook(0, tid)] = mul * 7 - 21;
}

kernel void simple_block_kernel(global int* res) {
  int multiplier = 3;
  size_t tid = get_global_id(0);

  void (^kernelBlock)(void) = ^{
    block_fn(tid, multiplier, res);
  };

  res[hook(0, tid)] = -1;
  queue_t def_q = get_default_queue();
  ndrange_t ndrange = ndrange_1D(1);
  int enq_res = enqueue_kernel(def_q, 0x1, ndrange, kernelBlock);
  if (enq_res != 0) {
    res[hook(0, tid)] = -1;
    return;
  }
}