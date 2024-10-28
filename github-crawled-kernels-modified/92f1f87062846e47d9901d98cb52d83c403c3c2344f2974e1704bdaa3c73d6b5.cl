//{"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void non_uniform_work_groups(global int* output) {
  int i = get_global_linear_id();
  output[hook(0, i)] = get_local_linear_id();

  int end = get_global_size(0) * get_global_size(1) * get_global_size(2);
  if (i == end - 1) {
    output[hook(0, end)] = get_local_size(0);
    output[hook(0, end + 1)] = get_local_size(1);
    output[hook(0, end + 2)] = get_local_size(2);
    output[hook(0, end + 3)] = get_enqueued_local_size(0);
    output[hook(0, end + 4)] = get_enqueued_local_size(1);
    output[hook(0, end + 5)] = get_enqueued_local_size(2);
  }
}