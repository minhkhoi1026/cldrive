//{"ht":5,"nite":6,"res":7,"wd":4,"x1":0,"x2":2,"y1":1,"y2":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_tile(global float* x1, global float* y1, global float* x2, global float* y2, global int* wd, global int* ht, global int* nite, global int* res) {
 private
  int ix;
 private
  int iy;
 private
  float x;
 private
  float y;
 private
  float ar;
 private
  float ai;
 private
  float a;
 private
  int ite;
 private
  float LOCALx1 = *x1;
 private
  float LOCALx2 = *x2;
 private
  float LOCALy1 = *y1;
 private
  float LOCALy2 = *y2;
 private
  int LOCALwd = *wd;
 private
  int LOCALht = *ht;
 private
  int LOCALnite = *nite;

 private
  int threadnumx = get_global_id(0);
 private
  int numthreadsx = get_global_size(0);

 private
  int threadnumy = get_global_id(1);
 private
  int numthreadsy = get_global_size(1);

  LOCALx2 -= LOCALx1;
  LOCALy2 -= LOCALy1;
  iy = 0;

 private
  int fromy;
 private
  int uptoy;
 private
  int fromx;
 private
  int uptox;

  if (numthreadsy > LOCALht) {
    if (threadnumy < LOCALht)
      fromy = threadnumy;
    else
      return;
  } else {
    fromy = (1.0 * LOCALht / numthreadsy) * threadnumy;
    uptoy = (1.0 * LOCALht / numthreadsy) * (threadnumy + 1);
  }

  if (numthreadsx > LOCALwd) {
    if (threadnumx < LOCALwd)
      fromx = threadnumx;
    else
      return;
  } else {
    fromx = (LOCALwd / numthreadsx) * threadnumx;
    uptox = (LOCALwd / numthreadsx) * (threadnumx + 1);
  }

  for (iy = fromy; iy < uptoy; iy++) {
    y = (iy * LOCALy2) / LOCALht + LOCALy1;

    for (ix = fromx; ix < uptox; ix++) {
      x = (ix * LOCALx2) / LOCALwd + LOCALx1;

      ar = x;
      ai = y;
      for (ite = 0; ite < LOCALnite; ite++) {
        a = (ar * ar) + (ai * ai);
        if (a > 4)
          break;
        a = ar * ar - ai * ai;
        ai *= 2 * ar;
        ar = a + x;
        ai += y;
      }
      res[hook(7, iy * LOCALwd + ix)] = LOCALnite - ite;
    }
  }
}