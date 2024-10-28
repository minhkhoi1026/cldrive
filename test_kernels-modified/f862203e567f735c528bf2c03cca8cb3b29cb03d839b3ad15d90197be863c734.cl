//{"distances":1,"minimums":2,"size":3,"visited":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void min_distance(global int* visited, global int* distances, global int* minimums, const int size) {
  int min = (__builtin_inff());
  for (int k = 0; k < size; k++) {
    if (!visited[hook(0, k)] && distances[hook(1, k)] <= min) {
      min = distances[hook(1, k)];
      *minimums = k;
    }
  }
}