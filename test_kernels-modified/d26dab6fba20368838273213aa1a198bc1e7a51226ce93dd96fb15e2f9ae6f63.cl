//{"memsize":1,"mybuf":3,"mybuf_mid":2,"ptr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel5_move(global char* ptr, unsigned long memsize) {
  int i, j;
  int idx = get_global_id(0);
  unsigned long n = memsize / (1024 * 1024);
  int total_num_threads = get_global_size(0);

  unsigned int half_count = (1024 * 1024) / sizeof(unsigned int) / 2;
  for (i = idx; i < n; i += total_num_threads) {
    global unsigned int* mybuf = (global unsigned int*)(ptr + i * (1024 * 1024));
    global unsigned int* mybuf_mid = (global unsigned int*)(ptr + i * (1024 * 1024) + (1024 * 1024) / 2);
    for (j = 0; j < half_count; j++) {
      mybuf_mid[hook(2, j)] = mybuf[hook(3, j)];
    }

    for (j = 0; j < half_count - 8; j++) {
      mybuf[hook(3, j + 8)] = mybuf_mid[hook(2, j)];
    }

    for (j = 0; j < 8; j++) {
      mybuf[hook(3, j)] = mybuf_mid[hook(2, half_count - 8 + j)];
    }
  }

  return;
}