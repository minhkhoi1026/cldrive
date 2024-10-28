//{"inWidth":1,"offset":2,"outDest":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void greaterthan(global float* outDest, int inWidth, int offset) {
  int x = (int)get_global_id(0);
  int y = (int)get_global_id(1);
  int x_cmp = x - offset + 3;
  int y_cmp = offset - 1 - y;

  int index = (y * inWidth) + x;

  if (x < inWidth && y < inWidth) {
    outDest[hook(0, index)] = (x_cmp > y_cmp) ? 1.0f : -1.0f;
  }
}