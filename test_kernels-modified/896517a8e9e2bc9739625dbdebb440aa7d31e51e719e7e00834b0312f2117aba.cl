//{"F":1,"S":0,"cols":2,"diagonal":4,"penalty":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int max3(int a, int b, int c) {
  int k = a > b ? a : b;
  return k > c ? k : c;
}

kernel void rhomboid(global const int* S, global int* F, int cols, int penalty, int diagonal) {
  int bx = get_group_id(0);
  int tx = get_local_id(0);
  int height = (cols - 1) / 32;
  int margin = 1;
  int r0 = diagonal < 2 * height ? margin - 1 + 32 * (1 - bx + diagonal / 2) : cols - 1 - 32 * bx;
  int c0 = diagonal < 2 * height ? margin - ((diagonal + 1) & 1) * 32 + 2 * bx * 32 : margin + (diagonal + 1 - 2 * (cols - 1) / 32) * 32 + 2 * bx * 32;
  int r = r0 - tx;
  c0 = c0 + tx;
  for (int k = 0; k < 32; ++k) {
    int c = c0 + k;
    if (0 < c && c < cols)
      F[hook(1, ((r) * cols + (c)))] = max3(F[hook(1, ((r - 1) * cols + (c - 1)))] + S[hook(0, ((r) * cols + (c)))], F[hook(1, ((r) * cols + (c - 1)))] - penalty, F[hook(1, ((r - 1) * cols + (c)))] - penalty);
    barrier(0x02);
  }
}