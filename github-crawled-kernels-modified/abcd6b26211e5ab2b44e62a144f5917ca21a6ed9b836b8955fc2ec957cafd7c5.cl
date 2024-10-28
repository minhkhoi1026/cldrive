//{"G":0,"Glong":4,"L":1,"Llong":3,"P":2,"Plong":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pointerSizeCast(global int* G) {
  local int L[1];
 private
  int P[1];

  local long* Llong = (local long*)&L[hook(1, 0)];
 private
  long* Plong = (private long*)&P[hook(2, 0)];
  global long* Glong = (global long*)&G[hook(0, 0)];

  Llong[hook(3, 0)] = 0xDEADBEEFCAFEBABE;
  Glong[hook(4, 0)] = Llong[hook(3, 0)];

  Plong[hook(5, 0)] = 0x0102030405060708;
  Glong[hook(4, 1)] = Plong[hook(5, 0)];
}