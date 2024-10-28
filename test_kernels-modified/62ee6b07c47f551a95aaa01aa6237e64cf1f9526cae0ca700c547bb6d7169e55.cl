//{"data":0,"scratch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void async_copy_unwaited(global int* data, local int* scratch) {
  event_t event = async_work_group_copy(scratch, data, get_local_size(0), 0);

  int i = get_local_id(0);
  data[hook(0, get_local_size(0) - i - 1)] = i;
}