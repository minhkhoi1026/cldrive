//{"memsize":1,"ptr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel0_local_write(global char* ptr, unsigned long memsize) {
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

    *p = pattern;
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

      *p = pattern;
      pattern = pattern << 1;
      mask = (mask << 1);
      if (mask == 0) {
        break;
      }
    }
  }
  return;
}