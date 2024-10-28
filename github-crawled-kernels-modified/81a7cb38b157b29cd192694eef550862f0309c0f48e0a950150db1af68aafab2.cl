//{"I":1,"T":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose_img(global int* restrict T, read_only image2d_t I) {
  const int r_T = get_global_id(1);
  const int c_T = get_global_id(0);

  int ncols_T = get_image_height(I);
  int nrows_T = get_image_width(I);

  if (c_T >= ncols_T || r_T >= nrows_T)
    return;

  const int r_A = c_T;
  const int c_A = r_T;

  T[hook(0, r_T * ncols_T + c_T)] = read_imagei(I, (int2)(c_A, r_A)).x;
}