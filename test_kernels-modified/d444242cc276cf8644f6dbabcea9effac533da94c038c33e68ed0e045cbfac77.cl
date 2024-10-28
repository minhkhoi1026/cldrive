//{"data":0,"events":2,"scratch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void wait_event_duplicates(global int* data, local int* scratch) {
  event_t events[4];
  events[hook(2, 0)] = async_work_group_copy(scratch, data, 1, 0);
  events[hook(2, 1)] = events[hook(2, 0)];
  events[hook(2, 2)] = async_work_group_copy(scratch + 1, data + 1, 3, 0);
  events[hook(2, 3)] = events[hook(2, 0)];

  wait_group_events(4, events);

  int i = get_local_id(0);
  data[hook(0, get_local_size(0) - i - 1)] = scratch[hook(1, i)];
}