//{"buf":5,"memsize":1,"offset":2,"p1":3,"p2":4,"ptr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_modtest_write(global char* ptr, unsigned long memsize, unsigned int offset, unsigned long p1, unsigned long p2) {
  int i;
  global unsigned long* buf = (global unsigned long*)ptr;
  int idx = get_global_id(0);
  unsigned long n = memsize / sizeof(unsigned long);
  int total_num_threads = get_global_size(0);

  for (i = idx; i < n; i += total_num_threads) {
    if ((i + 20 - offset) % 20 == 0) {
      buf[hook(5, i)] = p1;
    } else {
      buf[hook(5, i)] = p2;
    }
  }

  return;
}