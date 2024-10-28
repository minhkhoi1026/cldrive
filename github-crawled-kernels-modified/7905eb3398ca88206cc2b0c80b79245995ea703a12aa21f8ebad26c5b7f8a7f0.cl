//{"deltas":3,"depths":1,"m":0,"path_counts":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void init(int m, global int* depths, global int* path_counts, global float* deltas) {
  int id = get_global_id(0);
  if (id < m) {
    depths[hook(1, id)] = -1;
    path_counts[hook(2, id)] = 0;
    deltas[hook(3, id)] = 0;
  }
}