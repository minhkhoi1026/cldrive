//{"GRAPH_SIZE":3,"dist":1,"graph":0,"mid":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void UpdateKernel(global int* graph, global int* dist, global int* mid, const int GRAPH_SIZE) {
  const int global_id = get_global_id(0);
  const int k_id = mid[hook(2, 0)];

  int edge = graph[hook(0, global_id * GRAPH_SIZE + k_id)];
  int d = dist[hook(1, global_id)];
  if (edge > 0 && d > 0 && d > edge) {
    dist[hook(1, global_id)] = edge;
  }
}