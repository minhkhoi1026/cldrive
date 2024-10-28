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

kernel void multi_pointer_jumping_masked(global int* visited, global int* node_type, global int* offset, int n, global struct Auxiliary* auxiliary) {
  int id = get_global_id(0);
  int lid = get_local_id(0);
  int y, x, index;
  local bool flag;
  if (lid == 0)
    flag = false;
  barrier(0x01);
  for (int i = id; i < n; i += auxiliary->num_threads) {
    index = offset[hook(2, i)];
    if (node_type[hook(1, index)] == 0) {
      y = visited[hook(0, index)];
      x = visited[hook(0, y)];
      if (x != y) {
        flag = true;
        visited[hook(0, index)] = x;
      } else
        node_type[hook(1, index)] = -1;
    }
  }
  if (lid == 0)
    if (flag)
      auxiliary->pointer_jumping_flag = true;
}