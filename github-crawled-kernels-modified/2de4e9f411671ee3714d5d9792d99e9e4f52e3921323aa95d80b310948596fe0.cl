//{"build_column":2,"build_count":3,"join_result":4,"probe_column":0,"probe_count":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hash_join(global int* probe_column, const unsigned int probe_count, global int* build_column, const unsigned int build_count, global char* join_result) {
  int thread_idx = get_global_id(0);
  join_result[hook(4, thread_idx)] = build_column[hook(2, thread_idx)] == probe_column[hook(0, thread_idx)];
}