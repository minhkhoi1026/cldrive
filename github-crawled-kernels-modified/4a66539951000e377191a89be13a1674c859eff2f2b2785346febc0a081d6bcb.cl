//{"a":0,"b":1,"i":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef void (^bl_t)(local void*);
const bl_t block_G = (bl_t) ^ (local void* a) {};

kernel void device_side_enqueue(global int* a, global int* b, int i) {
  queue_t default_queue;

  unsigned flags = 0;

  ndrange_t ndrange;

  clk_event_t clk_event;

  clk_event_t event_wait_list;

  clk_event_t event_wait_list2[] = {clk_event};

  enqueue_kernel(default_queue, flags, ndrange, ^(void) {
    a[i] = b[i];
  });
  enqueue_kernel(default_queue, flags, ndrange, 2, &event_wait_list, &clk_event, ^(void) {
    a[i] = b[i];
  });

  enqueue_kernel(
      default_queue, flags, ndrange,
      ^(local void* p) {
        return;
      },
      256);
  char c;

  enqueue_kernel(
      default_queue, flags, ndrange,
      ^(local void* p) {
        return;
      },
      c);
  enqueue_kernel(
      default_queue, flags, ndrange, 2, event_wait_list2, &clk_event,
      ^(local void* p) {
        return;
      },
      256);
  enqueue_kernel(
      default_queue, flags, ndrange, 2, event_wait_list2, &clk_event,
      ^(local void* p) {
        return;
      },
      c);

  long l;

  enqueue_kernel(
      default_queue, flags, ndrange,
      ^(local void* p) {
        return;
      },
      l);

  enqueue_kernel(
      default_queue, flags, ndrange,
      ^(local void* p) {
        return;
      },
      4294967296L);

  void (^const block_A)(void) = ^{
    return;
  };

  void (^const block_B)(local void*) = ^(local void* a) {
    return;
  };

  unsigned size = get_kernel_work_group_size(block_A);

  size = get_kernel_work_group_size(block_B);

  size = get_kernel_preferred_work_group_size_multiple(block_A);

  size = get_kernel_preferred_work_group_size_multiple(block_G);
}