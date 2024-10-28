//{"buf":11,"err_addr":7,"err_count":6,"err_current":9,"err_expect":8,"err_second_read":10,"lb":3,"memsize":1,"offset":5,"pattern":2,"ptr":0,"sval":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_movinv32_read(global char* ptr, unsigned long memsize, unsigned int pattern, unsigned int lb, unsigned int sval, unsigned int offset, volatile global unsigned int* err_count, global unsigned long* err_addr, global unsigned long* err_expect, global unsigned long* err_current, global unsigned long* err_second_read) {
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
    unsigned int localp = buf[hook(11, i)];
    if (localp != ~pat) {
      do {
        unsigned int idx = atom_add(err_count, 1);
        idx = idx % 10;
        err_addr[hook(7, idx)] = (unsigned long)&buf[hook(11, i)];
        err_expect[hook(8, idx)] = (unsigned long)~pat;
        err_current[hook(9, idx)] = (unsigned long)localp;
        err_second_read[hook(10, idx)] = (unsigned long)(*&buf[hook(11, i)]);
      } while (0);
    }
  }

  return;
}