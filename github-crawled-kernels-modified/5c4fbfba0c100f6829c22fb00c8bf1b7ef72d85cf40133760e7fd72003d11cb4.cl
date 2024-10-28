//{"copiesPerWorkItem":3,"dst":0,"localBuffer":2,"src":1,"stride":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_async_stride_copy(global char4* dst, global char4* src, local char4* localBuffer, int copiesPerWorkItem, int stride) {
  event_t event;
  int copiesPerWorkgroup = copiesPerWorkItem * get_local_size(0);
  int i;
  event = async_work_group_strided_copy((local char4*)localBuffer, (global const char4*)(src + copiesPerWorkgroup * stride * get_group_id(0)), (size_t)copiesPerWorkgroup, (size_t)stride, 0);
  wait_group_events(1, &event);

  for (i = 0; i < copiesPerWorkItem; i++)
    localBuffer[hook(2, get_local_id(0) * copiesPerWorkItem + i)] = localBuffer[hook(2, get_local_id(0) * copiesPerWorkItem + i)] + (char4)(3);
  barrier(0x01);

  event = async_work_group_strided_copy((global char4*)(dst + copiesPerWorkgroup * stride * get_group_id(0)), (local const char4*)localBuffer, (size_t)copiesPerWorkgroup, (size_t)stride, 0);
  wait_group_events(1, &event);
}