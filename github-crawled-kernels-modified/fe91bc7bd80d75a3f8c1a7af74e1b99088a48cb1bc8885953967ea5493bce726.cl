//{"data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global int* data) {
  *data = get_global_offset(0) + get_num_groups(0) + get_enqueued_local_size(0) + get_global_size(0) + get_global_id(0) + get_group_id(0);
}