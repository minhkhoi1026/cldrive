//{"active_edges":3,"auxiliary":5,"e":4,"edge_list":1,"offset":2,"visited":0}
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

kernel void hook(global int* visited, global struct Edge* edge_list, global int* offset, global bool* active_edges, int e, global struct Auxiliary* auxiliary) {
  int id = get_global_id(0);
  int u, v, index;
  int Mx, Mn;
  for (int i = id; i < e; i += auxiliary->num_threads) {
    index = offset[hook(2, i)];
    u = edge_list[hook(1, index)].u;
    v = edge_list[hook(1, index)].v;
    if (active_edges[hook(3, index)] && (visited[hook(0, u)] != visited[hook(0, v)])) {
      auxiliary->flag = false;
      Mx = (visited[hook(0, u)] > visited[hook(0, v)]) ? visited[hook(0, u)] : visited[hook(0, v)];
      Mn = (visited[hook(0, u)] < visited[hook(0, v)]) ? visited[hook(0, u)] : visited[hook(0, v)];

      visited[hook(0, Mn)] = Mx;

    } else
      active_edges[hook(3, index)] = false;
  }
}