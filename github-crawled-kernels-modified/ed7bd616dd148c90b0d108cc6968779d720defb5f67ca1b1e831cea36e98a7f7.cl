//{"depths":3,"idx":1,"queue":2,"source":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void init(int source, global int* idx, global int* queue, global int* depths) {
  int tid = get_global_id(0);
  if (tid == 0) {
    depths[hook(3, source)] = 0;
    queue[hook(2, *idx)] = source;
    (*idx)++;
  }
}