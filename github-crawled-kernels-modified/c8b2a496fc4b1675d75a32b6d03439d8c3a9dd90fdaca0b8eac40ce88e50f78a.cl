//{"p":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_async_copy_and_prefetch(global float* p) {
  prefetch(p, 10);
  local float l[10];
  event_t e[2];
  async_work_group_copy(l, p, 10, 0);
  async_work_group_copy(p, l, 10, 0);
  wait_group_events(2, e);
}