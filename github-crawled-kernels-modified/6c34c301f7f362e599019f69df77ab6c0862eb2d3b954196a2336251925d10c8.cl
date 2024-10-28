//{"depths":4,"idx":1,"path_counts":3,"queue":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void insert(int src, global int* idx, global int* queue, global int* path_counts, global int* depths) {
  int id = get_global_id(0);
  if (id == 0) {
    depths[hook(4, src)] = 0;
    path_counts[hook(3, src)] = 1;
    queue[hook(2, *idx)] = src;
    (*idx)++;
  }
}