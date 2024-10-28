//{"buf":10,"err_addr":6,"err_count":5,"err_current":8,"err_expect":7,"err_second_read":9,"memsize":1,"offset":2,"p1":3,"p2":4,"ptr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_modtest_read(global char* ptr, unsigned long memsize, unsigned int offset, unsigned long p1, unsigned long p2, volatile global unsigned int* err_count, global unsigned long* err_addr, global unsigned long* err_expect, global unsigned long* err_current, global unsigned long* err_second_read) {
  int i;
  global unsigned long* buf = (global unsigned long*)ptr;
  int idx = get_global_id(0);
  unsigned long n = memsize / sizeof(unsigned long);
  int total_num_threads = get_global_size(0);

  unsigned long localp;
  for (i = idx; i < n; i += total_num_threads) {
    localp = buf[hook(10, i)];
    if ((i + 20 - offset) % 20 == 0) {
      if (localp != p1) {
        do {
          unsigned int idx = atom_add(err_count, 1);
          idx = idx % 10;
          err_addr[hook(6, idx)] = (unsigned long)&buf[hook(10, i)];
          err_expect[hook(7, idx)] = (unsigned long)p1;
          err_current[hook(8, idx)] = (unsigned long)localp;
          err_second_read[hook(9, idx)] = (unsigned long)(*&buf[hook(10, i)]);
        } while (0);
      }
    } else {
      if (localp != p2) {
        do {
          unsigned int idx = atom_add(err_count, 1);
          idx = idx % 10;
          err_addr[hook(6, idx)] = (unsigned long)&buf[hook(10, i)];
          err_expect[hook(7, idx)] = (unsigned long)p2;
          err_current[hook(8, idx)] = (unsigned long)localp;
          err_second_read[hook(9, idx)] = (unsigned long)(*&buf[hook(10, i)]);
        } while (0);
      }
    }
  }

  return;
}