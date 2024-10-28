//{"adjacency":1,"distances":2,"indexes":4,"size":3,"visited":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dijkstra(global int* visited, global int* adjacency, global int* distances, const int size, global int* indexes) {
  visited[hook(0, *indexes)] = 1;
  int j = get_local_id(0);
  if (!visited[hook(0, j)] && distances[hook(2, *indexes)] + adjacency[hook(1, j + *indexes * size)] < distances[hook(2, j)])
    distances[hook(2, j)] = distances[hook(2, *indexes)] + adjacency[hook(1, j + *indexes * size)];
}