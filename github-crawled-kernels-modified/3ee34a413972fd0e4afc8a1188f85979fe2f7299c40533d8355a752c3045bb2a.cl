//{"dst_0":4,"factor":1,"numElems":0,"src_0":2,"src_1":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void saxpy_dp_child(const int numElems, const float factor, global const float* src_0, global const float* src_1, global float* dst_0) {
  unsigned int gid = get_global_id(0);

  if (gid < numElems)
    dst_0[hook(4, gid)] = factor * src_0[hook(2, gid)] * src_1[hook(3, gid)];
}

kernel void saxpy_dp_wait_workgroup(const int numElems, const float factor, global const float* src_0, global const float* src_1, global float* dst_0) {
  unsigned int global_id = get_global_id(0);
  unsigned int global_sz = get_global_size(0);

  unsigned int child_global_sz = numElems / global_sz;
  unsigned int child_offset = global_id * child_global_sz;

  global const float* src_0_child = &src_0[hook(2, child_offset)];
  global const float* src_1_child = &src_1[hook(3, child_offset)];
  global float* dst_0_child = &dst_0[hook(4, child_offset)];

  queue_t defQ = get_default_queue();
  ndrange_t ndrange = ndrange_1D(child_global_sz);

  void (^saxpy_dp_child_wrapper)(void) = ^{
    saxpy_dp_child(child_global_sz, factor, src_0_child, src_1_child, dst_0_child);
  };

  int err_ret = enqueue_kernel(defQ, 0x2, ndrange, saxpy_dp_child_wrapper);
}