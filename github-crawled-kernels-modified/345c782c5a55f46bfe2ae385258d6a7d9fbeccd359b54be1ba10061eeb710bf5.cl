//{"inWidth":1,"offset":2,"outDest":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void greaterthan_m2(global float* outDest, int inWidth, int offset) {
  int x = (int)get_global_id(0);
  int y = (int)get_global_id(1);
  int x_cmp = x + offset;

  int index = (y * inWidth) + x;

  if (x < inWidth && y < inWidth) {
    outDest[hook(0, index)] = (x_cmp > -3) ? 1.0f : -1.0f;
  }
}