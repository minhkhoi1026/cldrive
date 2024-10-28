//{"auxiliary":3,"n":2,"node_type":1,"offset":4,"visited":0}
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

kernel void update_mask(global int* visited, global int* node_type, int n, global struct Auxiliary* auxiliary, int offset) {
  int id = get_global_id(0);
  for (int i = id; i < n; i += auxiliary->num_threads) {
    if (visited[hook(0, i + offset)] == (i + offset))
      node_type[hook(1, i + offset)] = 0;
    else
      node_type[hook(1, i + offset)] = 1;
  }
}