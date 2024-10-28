//{"buf":2,"memsize":1,"ptr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel7_write(global char* ptr, unsigned long memsize) {
  int i;
  global unsigned long* buf = (global unsigned long*)ptr;
  int idx = get_global_id(0);
  unsigned long n = memsize / sizeof(unsigned long);
  int total_num_threads = get_global_size(0);
  int rand_data_num = (1024 * 1024) / sizeof(unsigned long);

  for (i = idx; i < n; i += total_num_threads) {
    if (i < rand_data_num) {
      continue;
    }
    buf[hook(2, i)] = buf[hook(2, i % rand_data_num)];
  }

  return;
}