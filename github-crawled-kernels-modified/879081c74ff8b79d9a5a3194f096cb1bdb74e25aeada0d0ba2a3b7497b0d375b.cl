//{"buf":7,"err_addr":3,"err_count":2,"err_current":5,"err_expect":4,"err_second_read":6,"memsize":1,"ptr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel7_read(global char* ptr, unsigned long memsize, volatile global unsigned int* err_count, global unsigned long* err_addr, global unsigned long* err_expect, global unsigned long* err_current, global unsigned long* err_second_read) {
  int i;
  global unsigned long* buf = (global unsigned long*)ptr;
  int idx = get_global_id(0);
  unsigned long n = memsize / sizeof(unsigned long);
  int total_num_threads = get_global_size(0);
  unsigned long localp, expected;
  int rand_data_num = (1024 * 1024) / sizeof(unsigned long);

  for (i = idx; i < n; i += total_num_threads) {
    if (i < rand_data_num) {
      continue;
    }
    localp = buf[hook(7, i)];
    expected = ~(buf[hook(7, i % rand_data_num)]);
    if (localp != expected) {
      do {
        unsigned int idx = atom_add(err_count, 1);
        idx = idx % 10;
        err_addr[hook(3, idx)] = (unsigned long)&buf[hook(7, i)];
        err_expect[hook(4, idx)] = (unsigned long)expected;
        err_current[hook(5, idx)] = (unsigned long)localp;
        err_second_read[hook(6, idx)] = (unsigned long)(*&buf[hook(7, i)]);
      } while (0);
    }
  }
}