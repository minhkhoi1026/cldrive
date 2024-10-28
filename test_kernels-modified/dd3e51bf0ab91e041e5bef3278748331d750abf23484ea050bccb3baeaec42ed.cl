//{"A":4,"A[0]":3,"A[1 - buf]":6,"A[1]":5,"A[buf]":7,"final":2,"trace":1,"xyvals":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void k(global int* xyvals, global int* trace, global int* final) {
  local int A[2][4];
  int buf, x, y, i, j;
  int lid = get_local_id(0);

  if (lid == 0) {
    A[hook(4, 0)][hook(3, 0)] = 0;
    A[hook(4, 0)][hook(3, 1)] = 1;
    A[hook(4, 0)][hook(3, 2)] = 2;
    A[hook(4, 0)][hook(3, 3)] = 3;
    A[hook(4, 1)][hook(5, 0)] = -1;
    A[hook(4, 1)][hook(5, 1)] = -1;
    A[hook(4, 1)][hook(5, 2)] = -1;
    A[hook(4, 1)][hook(5, 3)] = -1;
  }
  barrier(0x01);

  x = (lid == 0 ? xyvals[hook(0, 0)] : xyvals[hook(0, 1)]);
  y = (lid == 0 ? xyvals[hook(0, 1)] : xyvals[hook(0, 0)]);
  buf = i = 0;
  int loop = 0;
  while (i < x) {
    j = 0;
    while (j < y) {
      barrier(0x01);
      {
        trace[hook(1, (lid * x * y * 8) + ((loop) * 8) + 0)] = A[hook(4, 0)][hook(3, 0)];
        trace[hook(1, (lid * x * y * 8) + ((loop) * 8) + 1)] = A[hook(4, 0)][hook(3, 1)];
        trace[hook(1, (lid * x * y * 8) + ((loop) * 8) + 2)] = A[hook(4, 0)][hook(3, 2)];
        trace[hook(1, (lid * x * y * 8) + ((loop) * 8) + 3)] = A[hook(4, 0)][hook(3, 3)];
        trace[hook(1, (lid * x * y * 8) + ((loop) * 8) + 4)] = A[hook(4, 1)][hook(5, 0)];
        trace[hook(1, (lid * x * y * 8) + ((loop) * 8) + 5)] = A[hook(4, 1)][hook(5, 1)];
        trace[hook(1, (lid * x * y * 8) + ((loop) * 8) + 6)] = A[hook(4, 1)][hook(5, 2)];
        trace[hook(1, (lid * x * y * 8) + ((loop) * 8) + 7)] = A[hook(4, 1)][hook(5, 3)];
        loop++;
      }
      while (0)
        ;
      ;
      A[hook(4, 1 - buf)][hook(6, lid)] = A[hook(4, buf)][hook(7, (lid + 1) % 4)];
      buf = 1 - buf;
      j++;
    }
    i++;
  }

  barrier(0x01);
  if (lid == 0) {
    final[hook(2, 0)] = A[hook(4, 0)][hook(3, 0)];
    final[hook(2, 1)] = A[hook(4, 0)][hook(3, 1)];
    final[hook(2, 2)] = A[hook(4, 0)][hook(3, 2)];
    final[hook(2, 3)] = A[hook(4, 0)][hook(3, 3)];
    final[hook(2, 4)] = A[hook(4, 1)][hook(5, 0)];
    final[hook(2, 5)] = A[hook(4, 1)][hook(5, 1)];
    final[hook(2, 6)] = A[hook(4, 1)][hook(5, 2)];
    final[hook(2, 7)] = A[hook(4, 1)][hook(5, 3)];
  }
}