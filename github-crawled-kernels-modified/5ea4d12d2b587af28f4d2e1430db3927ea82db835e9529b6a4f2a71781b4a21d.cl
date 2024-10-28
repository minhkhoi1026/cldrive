//{"dist":1,"graph":0,"graphSize":3,"min_k":4,"visited":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void UpdateDist(global int* graph, global int* dist, global bool* visited, const unsigned int graphSize, const int min_k) {
  const int id = get_global_id(0);
  const int width = get_global_size(0);

  visited[hook(2, min_k)] = true;
  for (int i = id; i < graphSize; i += width) {
    if (!visited[hook(2, i)] && dist[hook(1, i)] > graph[hook(0, i * graphSize + min_k)])
      dist[hook(1, i)] = graph[hook(0, i * graphSize + min_k)];
  }
}