//{"dif":3,"maps":1,"n":2,"page_ranks":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce_page_rank(global float* page_ranks, global float* maps, int n, global float* dif) {
  int j = get_global_id(0);
  int i;
  float new_rank;
  float old_rank;

  if (j < n) {
    old_rank = page_ranks[hook(0, j)];
    new_rank = 0.0f;
    for (i = 0; i < n; ++i) {
      new_rank += maps[hook(1, i * n + j)];
    }

    new_rank = ((1 - (0.85)) / n) + ((0.85) * new_rank);
    dif[hook(3, j)] = fabs(new_rank - old_rank) > dif[hook(3, j)] ? fabs(new_rank - old_rank) : dif[hook(3, j)];
    page_ranks[hook(0, j)] = new_rank;
  }
}