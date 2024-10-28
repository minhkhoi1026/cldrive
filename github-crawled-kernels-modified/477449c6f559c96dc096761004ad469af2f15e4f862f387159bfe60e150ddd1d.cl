//{"in_queue":1,"len":3,"nitems":0,"queue":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void push_frontier(int nitems, global int* in_queue, global int* queue, int len) {
  int tid = get_global_id(0);
  int vertex;
  int flag = 0;
  if (tid < nitems) {
    vertex = in_queue[hook(1, tid)];
    flag = 1;
  }
  if (flag == 1)
    queue[hook(2, len + tid)] = vertex;
}