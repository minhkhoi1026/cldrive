//{"fx":4,"fy":5,"image1":0,"image2":1,"imagesize":2,"windowsize":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void opticalflowkernel(global int* image1, global int* image2, int imagesize, int windowsize, global int* fx, global int* fy) {
  int row = get_global_id(1);
  int col = get_global_id(0);

  if (row > imagesize || col > imagesize)
    return;

  int bfirstconvolve = 1;
  float mincost = 1000000.0f;
  int frow = 0;
  int fcol = 0;
  int rw, cw, ii, jj, row_image1, row_image2, col_image1, col_image2;
  float cost;
  int val_image1;
  int val_image2;
  for (rw = -windowsize; rw <= windowsize; rw++)
    for (cw = -windowsize; cw <= windowsize; cw++) {
      cost = 0.0f;
      for (ii = -windowsize; ii <= windowsize; ii++)
        for (jj = -windowsize; jj <= windowsize; jj++) {
          row_image2 = row + rw + ii;
          col_image2 = col + cw + jj;
          row_image1 = row + ii;
          col_image1 = col + jj;
          val_image2 = (row_image2 >= 0 && row_image2 < imagesize && col_image2 >= 0 && col_image2 < imagesize) ? image2[hook(1, row_image2 * imagesize + col_image2)] : 0;
          val_image1 = (row_image1 >= 0 && row_image1 < imagesize && col_image1 >= 0 && col_image1 < imagesize) ? image1[hook(0, row_image1 * imagesize + col_image1)] : 0;
          cost = cost + (float)((val_image1 - val_image2) * (val_image1 - val_image2));
        }
      cost = cost / (float)((2 * windowsize + 1) * (2 * windowsize + 1));
      if (bfirstconvolve == 1) {
        bfirstconvolve = 0;
        mincost = cost;
        frow = rw;
        fcol = cw;
      } else if (cost <= mincost) {
        mincost = cost;
        frow = rw;
        fcol = cw;
      }
    }
  fy[hook(5, row * imagesize + col)] = frow;
  fx[hook(4, row * imagesize + col)] = fcol;
  return;
}