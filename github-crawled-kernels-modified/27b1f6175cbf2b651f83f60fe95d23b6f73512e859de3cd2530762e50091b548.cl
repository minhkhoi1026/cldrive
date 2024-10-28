//{"A":1,"As":3,"B":2,"Bs":4,"C":0,"trueLocalSize1":7,"uiWA":5,"uiWB":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mat_multiply(global unsigned short* C, global unsigned short* A, global unsigned short* B, local unsigned short* As, local unsigned short* Bs, int uiWA, int uiWB, int trueLocalSize1) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < uiWA && y < uiWB)
    C[hook(0, x * uiWB + y)] = A[hook(1, x * uiWB + y)] * B[hook(2, x * uiWB + y)];
}