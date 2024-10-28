//{"A":1,"B":2,"C":0,"uiWA":3,"uiWB":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mat_sub(global unsigned short* C, global unsigned short* A, global unsigned short* B, int uiWA, int uiWB) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < uiWA && y < uiWB)
    C[hook(0, x * uiWB + y)] = A[hook(1, x * uiWB + y)] - B[hook(2, x * uiWB + y)];
}