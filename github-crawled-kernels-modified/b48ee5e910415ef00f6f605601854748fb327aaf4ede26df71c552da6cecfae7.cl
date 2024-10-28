//{"maps":2,"n":4,"noutlinks":3,"page_ranks":1,"pages":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void map_page_rank(global int* pages, global float* page_ranks, global float* maps, global unsigned int* noutlinks, int n) {
  int i = get_global_id(0);

  int j;
  if (i < n) {
    float outbound_rank = page_ranks[hook(1, i)] / (float)noutlinks[hook(3, i)];
    for (j = 0; j < n; ++j) {
      maps[hook(2, i * n + j)] = pages[hook(0, i * n + j)] == 0 ? 0.0f : pages[hook(0, i * n + j)] * outbound_rank;
    }
  }
}