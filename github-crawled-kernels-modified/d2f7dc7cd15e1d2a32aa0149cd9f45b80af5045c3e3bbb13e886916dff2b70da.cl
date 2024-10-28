//{"counts":0,"prefix_sum":1,"stride":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prefix_sum_stride(global int* counts, global unsigned long* prefix_sum, const int stride) {
  int thread_idx = get_global_id(0);
  int n = get_global_size(0);
  unsigned long my_sum = prefix_sum[hook(1, thread_idx)];
  unsigned long neighbors_sum = prefix_sum[hook(1, thread_idx - stride)];
  barrier(0x02);
  if (thread_idx >= stride) {
    prefix_sum[hook(1, thread_idx)] = my_sum + neighbors_sum;
  }
  barrier(0x02);
}