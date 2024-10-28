//{"prof":1,"res":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clk_event_t_test(global int* res, global void* prof) {
  clk_event_t e1 = create_user_event();
  *res = is_valid_event(e1);
  retain_event(e1);
  set_user_event_status(e1, -42);
  capture_event_profiling_info(e1, 0x1, prof);
  release_event(e1);
}