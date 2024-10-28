//{"H":3,"I":0,"O":1,"W":4,"count":2,"iter":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int compute_c(uchar, uchar, uchar, uchar, uchar, uchar, uchar, uchar);
int compute_n(uchar, uchar, uchar, uchar, uchar, uchar, uchar, uchar);
int compute_d(uchar, uchar, uchar, uchar, uchar, uchar, uchar, uchar, int);
int delete_condition(int, int, int);
kernel void gh(global uchar* I, global uchar* O, global int* count, const int H, const int W, const int iter) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  uchar p1, p2, p3;
  uchar p8, p0, p4;
  uchar p7, p6, p5;
  uchar c, d, n;

  if (i > H || j > W)
    return;
  if ((p0 = I[hook(0, ((i) * W + j))])) {
    p1 = I[hook(0, ((i - 1) * W + j - 1))];
    p2 = I[hook(0, ((i - 1) * W + j))];
    p3 = I[hook(0, ((i - 1) * W + j + 1))];
    p4 = I[hook(0, ((i) * W + j + 1))];
    p5 = I[hook(0, ((i + 1) * W + j + 1))];
    p6 = I[hook(0, ((i + 1) * W + j))];
    p7 = I[hook(0, ((i + 1) * W + j - 1))];
    p8 = I[hook(0, ((i) * W + j - 1))];

    c = compute_c(p1, p2, p3, p8, p4, p7, p6, p5);
    n = compute_n(p1, p2, p3, p8, p4, p7, p6, p5);
    d = compute_d(p1, p2, p3, p8, p4, p7, p6, p5, iter);

    if (delete_condition(c, n, d)) {
      O[hook(1, ((i) * W + j))] = iter;
      atomic_inc(count);
    }
  }
}