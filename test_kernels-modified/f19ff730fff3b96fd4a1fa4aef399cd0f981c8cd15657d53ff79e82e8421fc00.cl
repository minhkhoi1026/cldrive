//{"dist":0,"graphSize":3,"mvalue":2,"visited":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FindMinDist(global int* dist, global bool* visited, global int* mvalue, const unsigned int graphSize) {
  const int id = get_global_id(0);
  const int width = get_global_size(0);

  int min_v = -1;
  int min_k = -1;
  for (int i = id; i < graphSize; i += width) {
    if ((min_v > dist[hook(0, i)] || min_v < 0) && !visited[hook(1, i)]) {
      min_v = dist[hook(0, i)];
      min_k = i;
    }
  }

  mvalue[hook(2, id * 2)] = min_v;
  mvalue[hook(2, id * 2 + 1)] = min_k;
}