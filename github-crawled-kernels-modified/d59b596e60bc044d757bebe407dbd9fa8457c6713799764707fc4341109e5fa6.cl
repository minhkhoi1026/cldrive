//{"buf":9,"err_addr":5,"err_count":4,"err_current":7,"err_expect":6,"err_second_read":8,"memsize":1,"p1":2,"p2":3,"ptr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_readwrite(global char* ptr, unsigned long memsize, unsigned long p1, unsigned long p2, volatile global unsigned int* err_count, global unsigned long* err_addr, global unsigned long* err_expect, global unsigned long* err_current, global unsigned long* err_second_read) {
  int i;
  global unsigned long* buf = (global unsigned long*)ptr;
  int idx = get_global_id(0);
  unsigned long n = memsize / sizeof(unsigned long);
  int total_num_threads = get_global_size(0);
  unsigned long localp;

  for (i = idx; i < n; i += total_num_threads) {
    localp = buf[hook(9, i)];

    if (localp != p1) {
      do {
        unsigned int idx = atom_add(err_count, 1);
        idx = idx % 10;
        err_addr[hook(5, idx)] = (unsigned long)&buf[hook(9, i)];
        err_expect[hook(6, idx)] = (unsigned long)p1;
        err_current[hook(7, idx)] = (unsigned long)localp;
        err_second_read[hook(8, idx)] = (unsigned long)(*&buf[hook(9, i)]);
      } while (0);
    }

    buf[hook(9, i)] = p2;
  }
}