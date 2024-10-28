//{"glob_size_arr":0,"val":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void block_fn(global unsigned int* val) {
  atomic_add(val, get_global_id(0));
}

kernel void compiler_device_enqueue(unsigned int glob_size_arr, global unsigned int* val) {
  size_t tid = get_global_id(0);

  for (int i = 0; i < glob_size_arr; i++) {
    ndrange_t ndrange = ndrange_1D(glob_size_arr);
    global unsigned int* v = val + tid;
    void (^kernelBlock)(void) = ^{
      block_fn(v);
    };
    queue_t q = get_default_queue();
    enqueue_kernel(q, 0x1, ndrange, kernelBlock);
  }
}