//{"counts":1,"hashed_data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void count_hash_values(global int* hashed_data, global int* counts) {
  int thread_idx = get_global_id(0);
  counts[hook(1, thread_idx)] = 0;
  int my_value = hashed_data[hook(0, thread_idx)];
  atomic_inc(&counts[hook(1, my_value)]);
}