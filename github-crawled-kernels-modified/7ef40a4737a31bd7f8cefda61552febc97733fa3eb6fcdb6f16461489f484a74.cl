//{"pA":0,"pB":1,"pC":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add(global int* pA, global int* pB, global int* pC) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int width = get_global_size(0);

  const int id = y * width + x;

  pC[hook(2, id)] = pA[hook(0, id)] + pB[hook(1, id)];
}