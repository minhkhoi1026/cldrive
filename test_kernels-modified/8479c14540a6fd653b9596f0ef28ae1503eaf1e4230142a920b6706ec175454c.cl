//{"buf":3,"memsize":1,"p1":2,"ptr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_write(global char* ptr, unsigned long memsize, unsigned long p1) {
  int i;
  global unsigned long* buf = (global unsigned long*)ptr;
  int idx = get_global_id(0);
  unsigned long n = memsize / sizeof(unsigned long);
  int total_num_threads = get_global_size(0);

  for (i = idx; i < n; i += total_num_threads) {
    buf[hook(3, i)] = p1;
  }

  return;
}