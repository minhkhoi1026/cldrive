//{"H":3,"I":0,"O":1,"W":4,"count":2,"iter":5,"smem":7,"smem[y + 16]":8,"smem[y + 1]":10,"smem[y - 1]":9,"smem[y]":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int compute_c(uchar, uchar, uchar, uchar, uchar, uchar, uchar, uchar);
int compute_n(uchar, uchar, uchar, uchar, uchar, uchar, uchar, uchar);
int compute_d(uchar, uchar, uchar, uchar, uchar, uchar, uchar, uchar, int);
int delete_condition(int, int, int);
kernel void gh_smem(global uchar* I, global uchar* O, global int* count, const int H, const int W, const int iter) {
  local uchar smem[16 + 2][16 + 2];

  int y = get_local_id(0);
  int x = get_local_id(1);
  int i = get_global_id(0);
  int j = get_global_id(1);

  int in;

  uchar p1, p2, p3;
  uchar p8, p0, p4;
  uchar p7, p6, p5;
  uchar c, d, n;

  i -= 1;
  j -= 1;

  in = i >= 0 && j >= 0;
  smem[hook(7, y)][hook(6, x)] = in ? I[hook(0, ((i) * W + j))] : 0;

  if (y < 2) {
    in = (j >= 0) && (i + 16 < H);
    smem[hook(7, y + 16)][hook(8, x)] = in ? I[hook(0, ((i + 16) * W + j))] : 0;
  }
  if (x < 2) {
    in = (i >= 0) && (j + 16) < W;
    smem[hook(7, y)][hook(6, x + 16)] = in ? I[hook(0, ((i) * W + j + 16))] : 0;
  }
  if (y < 2 && x < 2) {
    in = (i + 16 < H) && (j + 16 < W);
    smem[hook(7, y + 16)][hook(8, x + 16)] = in ? I[hook(0, ((i + 16) * W + j + 16))] : 0;
  }
  barrier(0x01);

  y += 1;
  x += 1;
  i += 1;
  j += 1;

  if (i > H || j > W)
    return;
  if ((p0 = smem[hook(7, y)][hook(6, x)])) {
    p1 = smem[hook(7, y - 1)][hook(9, x - 1)];
    p2 = smem[hook(7, y - 1)][hook(9, x)];
    p3 = smem[hook(7, y - 1)][hook(9, x + 1)];
    p4 = smem[hook(7, y)][hook(6, x + 1)];
    p5 = smem[hook(7, y + 1)][hook(10, x + 1)];
    p6 = smem[hook(7, y + 1)][hook(10, x)];
    p7 = smem[hook(7, y + 1)][hook(10, x - 1)];
    p8 = smem[hook(7, y)][hook(6, x - 1)];

    c = compute_c(p1, p2, p3, p8, p4, p7, p6, p5);
    n = compute_n(p1, p2, p3, p8, p4, p7, p6, p5);
    d = compute_d(p1, p2, p3, p8, p4, p7, p6, p5, iter);

    if (delete_condition(c, n, d)) {
      O[hook(1, ((i) * W + j))] = iter;
      atomic_inc(count);
    }
  }
}