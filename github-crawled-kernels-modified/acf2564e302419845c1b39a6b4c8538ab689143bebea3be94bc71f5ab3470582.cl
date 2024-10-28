//{"err_addr":3,"err_count":2,"err_current":5,"err_expect":4,"err_second_read":6,"memsize":1,"ptr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel0_local_read(global char* ptr, unsigned long memsize, volatile global unsigned int* err_count, global unsigned long* err_addr, global unsigned long* err_expect, global unsigned long* err_current, global unsigned long* err_second_read) {
  int i;
  global unsigned long* buf = (global unsigned long*)ptr;
  int idx = get_global_id(0);
  unsigned long n = memsize / (1024 * 1024);
  int total_num_threads = get_global_size(0);

  for (i = idx; i < n; i += total_num_threads) {
    global unsigned long* start_p = (global unsigned long)(ptr + i * (1024 * 1024));
    global unsigned long* end_p = (global unsigned long*)(ptr + (i + 1) * (1024 * 1024));
    global unsigned long* p = start_p;
    unsigned int pattern = 1;
    unsigned int mask = 8;

    if (*p != pattern) {
      do {
        unsigned int idx = atom_add(err_count, 1);
        idx = idx % 10;
        err_addr[hook(3, idx)] = (unsigned long)p;
        err_expect[hook(4, idx)] = (unsigned long)pattern;
        err_current[hook(5, idx)] = (unsigned long)*p;
        err_second_read[hook(6, idx)] = (unsigned long)(*p);
      } while (0);
    }

    pattern = (pattern << 1);
    while (p < end_p) {
      p = (global unsigned long*)(((unsigned long)start_p) | mask);

      if (p == start_p) {
        mask = (mask << 1);
        if (mask == 0) {
          break;
        }
        continue;
      }

      if (p >= end_p) {
        break;
      }

      if (*p != pattern) {
        do {
          unsigned int idx = atom_add(err_count, 1);
          idx = idx % 10;
          err_addr[hook(3, idx)] = (unsigned long)p;
          err_expect[hook(4, idx)] = (unsigned long)pattern;
          err_current[hook(5, idx)] = (unsigned long)*p;
          err_second_read[hook(6, idx)] = (unsigned long)(*p);
        } while (0);
      }

      pattern = pattern << 1;
      mask = (mask << 1);
      if (mask == 0) {
        break;
      }
    }
  }
  return;
}