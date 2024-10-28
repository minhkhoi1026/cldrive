//{"input":0,"output0":1,"output1":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel __attribute__((reqd_work_group_size(12, 1, 1))) void test_async_copy(const global int16* input, local int16* output0, global int16* output1) {
  size_t size = get_local_size(0);
  event_t event;
  event = async_work_group_copy(output0, input, size, event);
  wait_group_events(1, &event);

  unsigned lid = get_local_id(0);
  output1[hook(2, lid)] = output0[hook(1, lid)];
}

kernel void test_async_copy_general(const global int16* input, local int16* output0, global int16* output1) {
  size_t size = get_local_size(0);
  event_t event;
  event = async_work_group_copy(output0, input, size, event);
  wait_group_events(1, &event);

  unsigned lid = get_local_id(0);
  output1[hook(2, lid)] = output0[hook(1, lid)];
}