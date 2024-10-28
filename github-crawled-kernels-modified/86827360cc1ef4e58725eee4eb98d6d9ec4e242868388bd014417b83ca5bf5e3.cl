//{"copiesPerWorkItem":3,"dst":0,"localBuffer":2,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
;
;
;
;
;
;
kernel void compiler_async_copy_long2(global long2* dst, global long2* src, local long2* localBuffer, int copiesPerWorkItem) {
  event_t event;
  int copiesPerWorkgroup = copiesPerWorkItem * get_local_size(0);
  int i;
  event = async_work_group_copy((local long2*)localBuffer, (global const long2*)(src + copiesPerWorkgroup * get_group_id(0)), (size_t)copiesPerWorkgroup, 0);
  wait_group_events(1, &event);
  event = async_work_group_copy((global long2*)(dst + copiesPerWorkgroup * get_group_id(0)), (local const long2*)localBuffer, (size_t)copiesPerWorkgroup, 0);
  wait_group_events(1, &event);
}