//{"A":0,"B":3,"M":1,"N":2,"bc":7,"br":6,"cols":4,"penalty":5,"s":8,"t":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int max3(int a, int b, int c) {
  int k = a > b ? a : b;
  return k > c ? k : c;
}

kernel void rhombus(global const int* A, global const int* M, global const int* N, global int* B, int cols, int penalty, int br, int bc) {
  local int s[16 * 16];
  local int t[(32 + 1) * (32 + 2)];
  int bx = get_group_id(0);
  int tx = get_local_id(0);
  int rr = (br - bx) * 32 + 1;
  int cc = (bc + 2 * bx) * 32 + 1;

  int index = ((rr + tx) * cols + (cc - tx));
  int index_n = ((rr - 1) * cols + (cc + tx));
  int index_w = index - 1;
  int ii = 0;

  while (ii + tx < 16) {
    for (int ty = 0; ty < 16; ++ty)
      s[hook(8, ty * 16 + ii + tx)] = A[hook(0, ty * 16 + ii + tx)];
    ii += 32;
  }
  barrier(0x01);

  if (bc == 1 && bx == 0)
    for (int m = 0; m < 32; ++m) {
      int x = m - tx + 1;
      if (x > 0)
        B[hook(3, ((rr + tx) * cols + (x)))] = max3(B[hook(3, ((rr + tx - 1) * cols + (x - 1)))] + s[hook(8, M[rhook(1, rr + tx) * 16 + N[xhook(2, x))], B[hook(3, ((rr + tx - 1) * cols + (x)))] - penalty, B[hook(3, ((rr + tx) * cols + (x - 1)))] - penalty);
      barrier(0x02);
    }

  int y0 = (tx + 1) + (32 + 1);
  int y1 = (tx + 1) * (32 + 1);
  t[hook(9, tx)] = B[hook(3, ((rr + tx - 1) * cols + (cc - tx - 1)))];
  t[hook(9, y0)] = B[hook(3, index_w)];
  t[hook(9, y1)] = B[hook(3, index_n)];
  barrier(0x01);

  int y = M[hook(1, rr + tx)];
  int x = N[hook(2, cc - tx)];
  for (int k = 0; k < 32; ++k) {
    int nextX = N[hook(2, cc - tx + k + 1)];
    t[hook(9, (k + 2) * (32 + 1) + tx + 1)] = max3(t[hook(9, k * (32 + 1) + tx)] + s[hook(8, y * 16 + x)], t[hook(9, (k + 1) * (32 + 1) + tx)] - penalty, t[hook(9, (k + 1) * (32 + 1) + tx + 1)] - penalty);
    x = nextX;
    barrier(0x01);
  }

  for (int k = 0; k < 32; ++k)
    B[hook(3, ((rr + k) * cols + (cc - k + tx)))] = t[hook(9, (tx + 2) * (32 + 1) + k + 1)];
  barrier(0x02);

  if (cc + 32 == cols)
    for (int m = 0; m < 32; ++m) {
      int x = cc + 32 + m - tx;
      if (x < cols)
        B[hook(3, ((rr + tx) * cols + (x)))] = max3(B[hook(3, ((rr + tx - 1) * cols + (x - 1)))] + s[hook(8, M[rhook(1, rr + tx) * 16 + N[xhook(2, x))], B[hook(3, ((rr + tx - 1) * cols + (x)))] - penalty, B[hook(3, ((rr + tx) * cols + (x - 1)))] - penalty);
      barrier(0x02);
    }
}