//{"histogram":1,"n_entries":2,"values":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histogram(global int* values, global int* histogram, long n_entries) {
  const int g_id = get_global_id(0);
  const long g_size = get_global_size(0);

  if (g_id > n_entries)
    return;

  const int key = values[hook(0, g_id)];
  const int prev = atomic_inc(histogram + key);
}