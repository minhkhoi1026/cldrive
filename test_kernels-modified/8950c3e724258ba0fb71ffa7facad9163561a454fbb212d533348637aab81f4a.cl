//{"buf":6,"lb":3,"memsize":1,"offset":5,"pattern":2,"ptr":0,"sval":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_movinv32_write(global char* ptr, unsigned long memsize, unsigned int pattern, unsigned int lb, unsigned int sval, unsigned int offset) {
  int i;
  global unsigned int* buf = (global unsigned int*)ptr;
  int idx = get_global_id(0);
  unsigned long n = memsize / sizeof(unsigned int);
  int total_num_threads = get_global_size(0);

  unsigned int pat = pattern;
  unsigned int k = offset;
  for (i = 0; i < idx % 32; i++) {
    if (k >= 32) {
      k = 0;
      pat = lb;
    } else {
      pat = pat << 1;
      pat |= sval;
    }
  }

  for (i = idx; i < n; i += total_num_threads) {
    buf[hook(6, i)] = pat;
  }

  return;
}