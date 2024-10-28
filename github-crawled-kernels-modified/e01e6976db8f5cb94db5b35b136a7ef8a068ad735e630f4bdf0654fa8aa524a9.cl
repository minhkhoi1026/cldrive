//{"copiesPerWorkItem":3,"dst":0,"localBuffer":2,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_async_copy_char2(global char2* dst, global char2* src, local char2* localBuffer, int copiesPerWorkItem) {
  event_t event;
  int copiesPerWorkgroup = copiesPerWorkItem * get_local_size(0);
  int i;
  event = async_work_group_copy((local char2*)localBuffer, (global const char2*)(src + copiesPerWorkgroup * get_group_id(0)), (size_t)copiesPerWorkgroup, (event_t)0);
  wait_group_events(1, &event);
  event = async_work_group_copy((global char2*)(dst + copiesPerWorkgroup * get_group_id(0)), (local const char2*)localBuffer, (size_t)copiesPerWorkgroup, (event_t)0);
  wait_group_events(1, &event);
}