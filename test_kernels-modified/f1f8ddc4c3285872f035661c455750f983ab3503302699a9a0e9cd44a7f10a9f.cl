//{"active_edges":2,"auxiliary":4,"e":3,"edge_list":1,"visited":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct Edge {
  int u, v;
};

struct Auxiliary {
  int num_threads;
  int group_size;
  bool flag;
  bool iter_flag;
  bool pointer_jumping_flag;
};

kernel void process_cross_edges(global int* visited, global struct Edge* edge_list, global bool* active_edges, int e, global struct Auxiliary* auxiliary) {
  int id = get_global_id(0);
  int u, v;
  int Mx, Mn;
  for (int i = id; i < e; i += auxiliary->num_threads) {
    u = edge_list[hook(1, i)].u;
    v = edge_list[hook(1, i)].v;
    if (active_edges[hook(2, i)] && (visited[hook(0, u)] != visited[hook(0, v)])) {
      auxiliary->flag = false;

      Mn = (visited[hook(0, u)] < visited[hook(0, v)]) ? visited[hook(0, u)] : visited[hook(0, v)];
      visited[hook(0, visited[uhook(0, u))] = Mn;
      visited[hook(0, visited[vhook(0, v))] = Mn;
    } else
      active_edges[hook(2, i)] = false;
  }
}