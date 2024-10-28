//{"H":2,"W":3,"iter":4,"mat":0,"pos":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int compute_c(uchar, uchar, uchar, uchar, uchar, uchar, uchar, uchar);
int compute_n(uchar, uchar, uchar, uchar, uchar, uchar, uchar, uchar);
int compute_d(uchar, uchar, uchar, uchar, uchar, uchar, uchar, uchar, int);
int delete_condition(int, int, int);
kernel void delete (global uchar* mat, global uchar* pos, const int H, const int W, const int iter) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  int ij = i * W + j;

  if (i > H || j > W)
    return;

  if (pos[hook(1, ij)] == iter)
    mat[hook(0, ij)] = 0;
}