//{"buf":2,"memsize":1,"ptr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel5_init(global char* ptr, unsigned long memsize) {
  int i;
  global unsigned int* buf = (global unsigned int*)ptr;
  int idx = get_global_id(0);
  unsigned long n = memsize / 64;
  int total_num_threads = get_global_size(0);

  unsigned int p1 = 1;
  unsigned int p2;
  p1 = p1 << (idx % 32);
  p2 = ~p1;
  for (i = idx; i < n; i += total_num_threads) {
    buf[hook(2, i * 16)] = p1;
    buf[hook(2, i * 16 + 1)] = p1;
    buf[hook(2, i * 16 + 2)] = p2;
    buf[hook(2, i * 16 + 3)] = p2;
    buf[hook(2, i * 16 + 4)] = p1;
    buf[hook(2, i * 16 + 5)] = p1;
    buf[hook(2, i * 16 + 6)] = p2;
    buf[hook(2, i * 16 + 7)] = p2;
    buf[hook(2, i * 16 + 8)] = p1;
    buf[hook(2, i * 16 + 9)] = p1;
    buf[hook(2, i * 16 + 10)] = p2;
    buf[hook(2, i * 16 + 11)] = p2;
    buf[hook(2, i * 16 + 12)] = p1;
    buf[hook(2, i * 16 + 13)] = p1;
    buf[hook(2, i * 16 + 14)] = p2;
    buf[hook(2, i * 16 + 15)] = p2;
  }

  return;
}