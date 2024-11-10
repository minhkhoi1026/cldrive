//{"data":0,"scratch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void async_copy_local_race(global int* data, local int* scratch) {
  int i = get_local_id(0);

  scratch[hook(1, i)] = 0;
  event_t event = async_work_group_copy(scratch, data, get_local_size(0), 0);
  wait_group_events(1, &event);

  data[hook(0, get_local_size(0) - i - 1)] = scratch[hook(1, i)];
}