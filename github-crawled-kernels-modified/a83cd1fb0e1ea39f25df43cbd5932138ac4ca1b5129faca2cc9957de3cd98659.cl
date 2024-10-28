//{"A":8,"B":9,"_resz":7,"diffa":10,"diffb":11,"f":19,"feed":12,"feed2":14,"kill":13,"kill2":15,"resx":5,"resy":6,"speed":16,"strideoffset":4,"stridex":1,"stridey":2,"stridez":3,"timeinc":0,"w":20,"xo":17,"yo":18}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float vg_laplacian_2d(global float* f, int sx, int sy, int so, int resx, int resy, bool wrap) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  float xo[] = {-1, 0, +1, -1, 0, +1, -1, 0, +1};
  float yo[] = {+1, +1, +1, 0, 0, 0, -1, -1, -1};
  float w[] = {0.05, 0.20, 0.05, 0.20, -1.0, 0.2, 0.05, 0.2, 0.05};
  float out = 0;

  resx -= 1;
  resy -= 1;

  for (int i = 0; i < 9; i++) {
    int x1 = x + xo[hook(17, i)];
    int y1 = y + yo[hook(18, i)];
    if (wrap) {
      if (x1 < 0)
        x1 = resx;
      if (x1 > resx)
        x1 = 0;
      if (y1 < 0)
        y1 = resy;
      if (y1 > resy)
        y1 = 0;
    } else {
      if (x1 < 0)
        x1 = 0;
      if (x1 > resx)
        x1 = resx;
      if (y1 < 0)
        y1 = 0;
      if (y1 > resy)
        y1 = resy;
    }
    float v = f[hook(19, so + sx * x1 + sy * y1)] * w[hook(20, i)];
    out += v;
  }
  return out;
}

kernel void vg_gray_scott2d(float timeinc,

                            int stridex, int stridey, int stridez, int strideoffset, int resx, int resy, int _resz,

                            global float* A, global float* B,

                            float diffa, float diffb, float feed, float kill, float feed2, float kill2, float speed) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);
  int i = strideoffset + stridex * gidx + stridey * gidy;

  if (i >= stridex * stridey * stridez) {
    return;
  }

  float rate = A[hook(8, i)] * B[hook(9, i)] * B[hook(9, i)];

  float t = (float)gidx / resx;
  float f = feed + (feed2 - feed) * t;
  float k = kill + (kill2 - kill) * t;

  float feeda = f * (1.0 - A[hook(8, i)]);
  float la = vg_laplacian_2d(A, stridex, stridey, strideoffset, resx, resy, false);
  A[hook(8, i)] += (diffa * la - rate + feeda) * timeinc * speed;

  float killb = (k + f) * B[hook(9, i)];
  float lb = vg_laplacian_2d(B, stridex, stridey, strideoffset, resx, resy, false);
  B[hook(9, i)] += (diffb * lb + rate - killb) * timeinc * speed;
}