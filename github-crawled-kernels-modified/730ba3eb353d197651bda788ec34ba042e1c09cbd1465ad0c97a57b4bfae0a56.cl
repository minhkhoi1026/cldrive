//{"data":0,"scratch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void wait_event_chained(global int* data, local int* scratch) {
  event_t event;
  event = async_work_group_copy(scratch, data, 1, 0);
  for (int i = 1; i < 4; i++) {
    async_work_group_copy(scratch + i, data + i, 1, event);
  }
  wait_group_events(1, &event);

  int i = get_local_id(0);
  data[hook(0, get_local_size(0) - i - 1)] = scratch[hook(1, i)];
}