//{"ht":5,"nite":6,"res":7,"wd":4,"x1":0,"x2":2,"y1":1,"y2":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_tile(global float* x1, global float* y1, global float* x2, global float* y2, global int* wd, global int* ht, global int* nite, global int* res) {
  int ix;
  int iy;
  float x;
  float y;
  float ar;
  float ai;
  float a;
  int ite;
  float LOCALx1 = *x1;
  float LOCALx2 = *x2;
  float LOCALy1 = *y1;
  float LOCALy2 = *y2;
  int LOCALwd = *wd;
  int LOCALht = *ht;
  int LOCALnite = *nite;

 private
  float threadnumy = get_global_id(0);
 private
  float numthreadsy = get_global_size(0);

 private
  float threadnumx = get_global_id(1);
 private
  float numthreadsx = get_global_size(1);

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

  fromy = (LOCALht / numthreadsy) * threadnumy;
  uptoy = (LOCALht / numthreadsy) * (threadnumy + 1);

  fromx = (LOCALwd / numthreadsx) * threadnumx;
  uptox = (LOCALwd / numthreadsx) * (threadnumx + 1);

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