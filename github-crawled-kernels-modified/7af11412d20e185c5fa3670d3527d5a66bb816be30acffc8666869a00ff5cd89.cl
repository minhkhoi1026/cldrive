//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_workitem_builtin() {
  unsigned int x = get_work_dim();
  size_t y = get_global_size(0);
  y = get_global_id(0);
  y = get_local_size(0);
  y = get_local_id(0);
  y = get_num_groups(0);
  y = get_group_id(0);
  y = get_global_offset(0);
}