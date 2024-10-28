//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void async_copy_out_of_bounds(local int* src, global int* dst) {
  int l = get_local_id(0);
  src[hook(0, l)] = l;
  barrier(0x01);
  event_t event = async_work_group_copy(dst + 1, src, get_local_size(0), 0);
  wait_group_events(1, &event);
}