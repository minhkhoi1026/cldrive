//{"data":0,"events":2,"scratch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void wait_event_divergent(global int* data, local int* scratch) {
  int i = get_local_id(0);
  scratch[hook(1, i)] = 0;
  barrier(0x01);

  event_t events[2];
  events[hook(2, 0)] = async_work_group_copy(scratch, data, 1, 0);
  events[hook(2, 1)] = async_work_group_copy(scratch + 1, data + 1, 1, 0);

  wait_group_events(1, events + i);

  data[hook(0, get_local_size(0) - i - 1)] = scratch[hook(1, i)];
}