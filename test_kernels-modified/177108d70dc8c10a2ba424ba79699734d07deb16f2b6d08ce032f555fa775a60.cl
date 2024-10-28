//{"auxiliary":4,"n":3,"node_type":1,"offset":2,"visited":0}
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

kernel void multi_pointer_jumping_unmasked(global int* visited, global int* node_type, global int* offset, int n, global struct Auxiliary* auxiliary) {
  int id = get_global_id(0);
  int lid = get_local_id(0);
  int y, x;
  for (int i = id; i < n; i += auxiliary->num_threads) {
    if (node_type[hook(1, i)] == 1) {
      y = visited[hook(0, i)];
      x = visited[hook(0, y)];
      if (x != y)
        visited[hook(0, i)] = x;
    }
  }
}