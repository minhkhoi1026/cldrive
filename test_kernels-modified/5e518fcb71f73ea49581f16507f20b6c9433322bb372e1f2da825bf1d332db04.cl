//{"auxiliary":2,"n":1,"visited":0}
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

kernel void initialize(global int* visited, int n, global struct Auxiliary* auxiliary) {
  int id = get_global_id(0);
  for (int i = id; i < n; i += auxiliary->num_threads)
    visited[hook(0, i)] = i;
}