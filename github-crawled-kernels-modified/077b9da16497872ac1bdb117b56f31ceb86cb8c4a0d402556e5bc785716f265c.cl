//{"counts":0,"prefix_sum":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prefix_sum_init(global int* counts, global unsigned long* prefix_sum) {
  int thread_idx = get_global_id(0);
  int n = get_global_size(0);
  prefix_sum[hook(1, thread_idx)] = (thread_idx > 0) ? counts[hook(0, thread_idx - 1)] : 0;
}