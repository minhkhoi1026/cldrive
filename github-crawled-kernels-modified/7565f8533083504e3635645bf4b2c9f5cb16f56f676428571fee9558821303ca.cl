//{"in":0,"num_values":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) kernel void test_async(global const float16* in, const int num_values, local float16* out) {
  event_t event = async_work_group_copy(out, in, num_values, 0);
  event_t event2 = async_work_group_strided_copy(out + num_values, in, num_values, num_values, 0);

  wait_group_events(1, &event);
  wait_group_events(1, &event2);

  prefetch(in + 2 * num_values, num_values);
}