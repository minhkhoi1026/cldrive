//{"copiesPerWorkItem":4,"copiesPerWorkgroup":3,"dst":1,"localBuffer":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_async_copy_global_to_local(const global char8* src, global char8* dst, local char8* localBuffer, int copiesPerWorkgroup, int copiesPerWorkItem) {
  int i;

  for (i = 0; i < copiesPerWorkItem; i++)
    localBuffer[hook(2, get_local_id(0) * copiesPerWorkItem + i)] = (char8)(char)0;

  barrier(0x01);
  event_t event;
  event = async_work_group_copy((local char8*)localBuffer, (global const char8*)(src + copiesPerWorkgroup * get_group_id(0)), (size_t)copiesPerWorkgroup, (event_t)0);

  wait_group_events(1, &event);
  for (i = 0; i < copiesPerWorkItem; i++)
    dst[hook(1, get_global_id(0) * copiesPerWorkItem + i)] = localBuffer[hook(2, get_local_id(0) * copiesPerWorkItem + i)];
}