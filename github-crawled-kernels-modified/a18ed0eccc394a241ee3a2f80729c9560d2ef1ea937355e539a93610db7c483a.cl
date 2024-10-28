//{"data":0,"scratch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void async_copy_loop_divergent(global int* data, local int* scratch) {
  int i = get_local_id(0);

  event_t event = 0;
  for (int j = 0; j < get_local_size(0); j++) {
    int offset = j;
    if (i == 2 && j == 2) {
      offset = 0;
    }

    event = async_work_group_copy(scratch + offset, data + offset, 1, event);
  }
  wait_group_events(1, &event);

  data[hook(0, get_local_size(0) - i - 1)] = scratch[hook(1, i)];
}