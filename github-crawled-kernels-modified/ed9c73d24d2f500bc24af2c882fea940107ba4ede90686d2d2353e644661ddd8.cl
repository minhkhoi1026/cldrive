//{"a":4,"ee":6,"hh":5,"nx":1,"ny":2,"nz":3,"src":0,"w_ex111":7,"w_ey111":8,"w_ez111":9,"w_hx011":13,"w_hx111":10,"w_hy011":14,"w_hy111":11,"w_hz011":15,"w_hz111":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ecomp_kern(float4 src, int nx, int ny, int nz, float4 a, global float4* hh, global float4* ee) {
  float4 zero4 = (float4){0.0f, 0.0f, 0.0f, 0.0f};
  float4 one4 = (float4){1.0f, 1.0f, 1.0f, 1.0f};
  float4 mask_xyz0 = (float4){1.0f, 1.0f, 1.0f, 0.0f};
  float4 mask_0yzw = (float4){0.0f, 1.0f, 1.0f, 1.0f};
  float4 ax4 = (float4){a.x, a.x, a.x, a.x};
  float4 ay4 = (float4){a.y, a.y, a.y, a.y};
  float4 az4 = (float4){a.z, a.z, a.z, a.z};

  local float4 w_ex111[260];
  local float4 w_ey111[260];
  local float4 w_ez111[260];

  local float4 w_hx111[130];
  local float4 w_hy111[130];
  local float4 w_hz111[130];

  local float4 w_hx011[65];
  local float4 w_hy011[65];
  local float4 w_hz011[65];

  int nyz = ny * nz;

  int mx = nx - 1;
  int my = ny - 1;
  int mz = nz - 1;

  int nx2 = nx / 2;
  int ny2 = ny / 2;

  int gtx = get_global_id(0);
  int gty = get_global_id(1);
  int gtz = get_global_id(2);

  int x1 = gtx;
  int y1 = 4 * gty;
  int z1 = gtz;

  int x0 = (x1 + nx - 1) % nx;
  int y0 = (y1 + ny - 1) % ny;

  int y2 = y1 + 1;
  int y3 = y2 + 1;
  int y4 = y3 + 1;

  int tz = gtz;
  int tz1 = 1 + tz;

  int gci1113 = 3 * (x1 * nyz + y1 * nz) + z1;
  int gci1213 = 3 * (x1 * nyz + y2 * nz) + z1;
  int gci1313 = 3 * (x1 * nyz + y3 * nz) + z1;
  int gci1413 = 3 * (x1 * nyz + y4 * nz) + z1;

  w_ex111[hook(7, tz1)] = ee[hook(6, gci1113 + 0 * nz)];
  w_ey111[hook(8, tz1)] = ee[hook(6, gci1113 + 1 * nz)];
  w_ez111[hook(9, tz1)] = ee[hook(6, gci1113 + 2 * nz)];

  w_ex111[hook(7, tz1 + 65)] = ee[hook(6, gci1213 + 0 * nz)];
  w_ey111[hook(8, tz1 + 65)] = ee[hook(6, gci1213 + 1 * nz)];
  w_ez111[hook(9, tz1 + 65)] = ee[hook(6, gci1213 + 2 * nz)];

  w_ex111[hook(7, tz1 + 130)] = ee[hook(6, gci1313 + 0 * nz)];
  w_ey111[hook(8, tz1 + 130)] = ee[hook(6, gci1313 + 1 * nz)];
  w_ez111[hook(9, tz1 + 130)] = ee[hook(6, gci1313 + 2 * nz)];

  w_ex111[hook(7, tz1 + 195)] = ee[hook(6, gci1413 + 0 * nz)];
  w_ey111[hook(8, tz1 + 195)] = ee[hook(6, gci1413 + 1 * nz)];
  w_ez111[hook(9, tz1 + 195)] = ee[hook(6, gci1413 + 2 * nz)];

  float t = src.x;
  float q = src.y * sin(t * src.z);

  float4 q4 = (float4){q, q, q, q};

  {
    int gci1013 = 3 * (x1 * nyz + y0 * nz) + z1;
    int gci1113 = 3 * (x1 * nyz + y1 * nz) + z1;
    int gci0113 = 3 * (x0 * nyz + y1 * nz) + z1;

    w_hx111[hook(10, tz1)] = hh[hook(5, gci1013 + 0 * nz)];
    w_hy111[hook(11, tz1)] = hh[hook(5, gci1013 + 1 * nz)];
    w_hz111[hook(12, tz1)] = hh[hook(5, gci1013 + 2 * nz)];

    w_hx111[hook(10, tz1 + 65)] = hh[hook(5, gci1113 + 0 * nz)];
    w_hy111[hook(11, tz1 + 65)] = hh[hook(5, gci1113 + 1 * nz)];
    w_hz111[hook(12, tz1 + 65)] = hh[hook(5, gci1113 + 2 * nz)];

    w_hx011[hook(13, tz1)] = hh[hook(5, gci0113 + 0 * nz)];
    w_hy011[hook(14, tz1)] = hh[hook(5, gci0113 + 1 * nz)];
    w_hz011[hook(15, tz1)] = hh[hook(5, gci0113 + 2 * nz)];

    if (tz == 0) {
      w_hx111[hook(10, 0)] = w_hx111[hook(10, 64)].wxyz;
      w_hy111[hook(11, 0)] = w_hy111[hook(11, 64)].wxyz;
      w_hz111[hook(12, 0)] = w_hz111[hook(12, 64)].wxyz;

      w_hx111[hook(10, 0 + 65)] = w_hx111[hook(10, 64 + 65)].wxyz;
      w_hy111[hook(11, 0 + 65)] = w_hy111[hook(11, 64 + 65)].wxyz;
      w_hz111[hook(12, 0 + 65)] = w_hz111[hook(12, 64 + 65)].wxyz;

      w_hx011[hook(13, 0)] = w_hx011[hook(13, 64)].wxyz;
      w_hy011[hook(14, 0)] = w_hy011[hook(14, 64)].wxyz;
      w_hz011[hook(15, 0)] = w_hz011[hook(15, 64)].wxyz;
    }

    barrier(0x01);

    w_ex111[hook(7, tz1)] += az4 * (w_hy111[hook(11, tz + 65)] - w_hy111[hook(11, tz1 + 65)]) + ay4 * (w_hz111[hook(12, tz1 + 65)] - w_hz111[hook(12, tz1)]);
    w_ey111[hook(8, tz1)] += ax4 * (w_hz011[hook(15, tz1)] - w_hz111[hook(12, tz1 + 65)]) + az4 * (w_hx111[hook(10, tz1 + 65)] - w_hx111[hook(10, tz + 65)]);
    w_ez111[hook(9, tz1)] += ay4 * (w_hx111[hook(10, tz1)] - w_hx111[hook(10, tz1 + 65)]) + ax4 * (w_hy111[hook(11, tz1 + 65)] - w_hy011[hook(14, tz1)]);

    float4 maska = (gtx == 0) ? zero4 : one4;
    maska = (gtx == mx) ? zero4 : maska;

    float4 maskb = (gty == 0) ? zero4 : one4;

    float4 maskc = (gtz == 0) ? mask_0yzw : one4;
    maskc = (gtz == mz) ? mask_xyz0 : maskc;

    float4 tmp4 = w_ez111[hook(9, tz1)];

    w_ez111[hook(9, tz1)] = ((gty == 16 && gtx == 16) ? q4 : tmp4);
  }

  {
    int gci1013 = 3 * (x1 * nyz + y1 * nz) + z1;
    int gci1113 = 3 * (x1 * nyz + y2 * nz) + z1;
    int gci0113 = 3 * (x0 * nyz + y2 * nz) + z1;

    w_hx111[hook(10, tz1)] = hh[hook(5, gci1013 + 0 * nz)];
    w_hy111[hook(11, tz1)] = hh[hook(5, gci1013 + 1 * nz)];
    w_hz111[hook(12, tz1)] = hh[hook(5, gci1013 + 2 * nz)];

    w_hx111[hook(10, tz1 + 65)] = hh[hook(5, gci1113 + 0 * nz)];
    w_hy111[hook(11, tz1 + 65)] = hh[hook(5, gci1113 + 1 * nz)];
    w_hz111[hook(12, tz1 + 65)] = hh[hook(5, gci1113 + 2 * nz)];

    w_hx011[hook(13, tz1)] = hh[hook(5, gci0113 + 0 * nz)];
    w_hy011[hook(14, tz1)] = hh[hook(5, gci0113 + 1 * nz)];
    w_hz011[hook(15, tz1)] = hh[hook(5, gci0113 + 2 * nz)];

    if (tz == 0) {
      w_hx111[hook(10, 0)] = w_hx111[hook(10, 64)].wxyz;
      w_hy111[hook(11, 0)] = w_hy111[hook(11, 64)].wxyz;
      w_hz111[hook(12, 0)] = w_hz111[hook(12, 64)].wxyz;

      w_hx111[hook(10, 0 + 65)] = w_hx111[hook(10, 64 + 65)].wxyz;
      w_hy111[hook(11, 0 + 65)] = w_hy111[hook(11, 64 + 65)].wxyz;
      w_hz111[hook(12, 0 + 65)] = w_hz111[hook(12, 64 + 65)].wxyz;

      w_hx011[hook(13, 0)] = w_hx011[hook(13, 64)].wxyz;
      w_hy011[hook(14, 0)] = w_hy011[hook(14, 64)].wxyz;
      w_hz011[hook(15, 0)] = w_hz011[hook(15, 64)].wxyz;
    }

    barrier(0x01);

    w_ex111[hook(7, tz1 + 65)] += az4 * (w_hy111[hook(11, tz + 65)] - w_hy111[hook(11, tz1 + 65)]) + ay4 * (w_hz111[hook(12, tz1 + 65)] - w_hz111[hook(12, tz1)]);
    w_ey111[hook(8, tz1 + 65)] += ax4 * (w_hz011[hook(15, tz1)] - w_hz111[hook(12, tz1 + 65)]) + az4 * (w_hx111[hook(10, tz1 + 65)] - w_hx111[hook(10, tz + 65)]);
    w_ez111[hook(9, tz1 + 65)] += ay4 * (w_hx111[hook(10, tz1)] - w_hx111[hook(10, tz1 + 65)]) + ax4 * (w_hy111[hook(11, tz1 + 65)] - w_hy011[hook(14, tz1)]);

    float4 maska = (gtx == 0) ? zero4 : one4;
    maska = (gtx == mx) ? zero4 : maska;

    float4 maskc = (gtz == 0) ? mask_0yzw : one4;
    maskc = (gtz == mz) ? mask_xyz0 : maskc;
  }

  {
    int gci1013 = 3 * (x1 * nyz + y2 * nz) + z1;
    int gci1113 = 3 * (x1 * nyz + y3 * nz) + z1;
    int gci0113 = 3 * (x0 * nyz + y3 * nz) + z1;

    w_hx111[hook(10, tz1)] = hh[hook(5, gci1013 + 0 * nz)];
    w_hy111[hook(11, tz1)] = hh[hook(5, gci1013 + 1 * nz)];
    w_hz111[hook(12, tz1)] = hh[hook(5, gci1013 + 2 * nz)];

    w_hx111[hook(10, tz1 + 65)] = hh[hook(5, gci1113 + 0 * nz)];
    w_hy111[hook(11, tz1 + 65)] = hh[hook(5, gci1113 + 1 * nz)];
    w_hz111[hook(12, tz1 + 65)] = hh[hook(5, gci1113 + 2 * nz)];

    w_hx011[hook(13, tz1)] = hh[hook(5, gci0113 + 0 * nz)];
    w_hy011[hook(14, tz1)] = hh[hook(5, gci0113 + 1 * nz)];
    w_hz011[hook(15, tz1)] = hh[hook(5, gci0113 + 2 * nz)];

    if (tz == 0) {
      w_hx111[hook(10, 0)] = w_hx111[hook(10, 64)].wxyz;
      w_hy111[hook(11, 0)] = w_hy111[hook(11, 64)].wxyz;
      w_hz111[hook(12, 0)] = w_hz111[hook(12, 64)].wxyz;

      w_hx111[hook(10, 0 + 65)] = w_hx111[hook(10, 64 + 65)].wxyz;
      w_hy111[hook(11, 0 + 65)] = w_hy111[hook(11, 64 + 65)].wxyz;
      w_hz111[hook(12, 0 + 65)] = w_hz111[hook(12, 64 + 65)].wxyz;

      w_hx011[hook(13, 0)] = w_hx011[hook(13, 64)].wxyz;
      w_hy011[hook(14, 0)] = w_hy011[hook(14, 64)].wxyz;
      w_hz011[hook(15, 0)] = w_hz011[hook(15, 64)].wxyz;
    }

    barrier(0x01);

    w_ex111[hook(7, tz1 + 130)] += az4 * (w_hy111[hook(11, tz + 65)] - w_hy111[hook(11, tz1 + 65)]) + ay4 * (w_hz111[hook(12, tz1 + 65)] - w_hz111[hook(12, tz1)]);
    w_ey111[hook(8, tz1 + 130)] += ax4 * (w_hz011[hook(15, tz1)] - w_hz111[hook(12, tz1 + 65)]) + az4 * (w_hx111[hook(10, tz1 + 65)] - w_hx111[hook(10, tz + 65)]);
    w_ez111[hook(9, tz1 + 130)] += ay4 * (w_hx111[hook(10, tz1)] - w_hx111[hook(10, tz1 + 65)]) + ax4 * (w_hy111[hook(11, tz1 + 65)] - w_hy011[hook(14, tz1)]);

    float4 maska = (gtx == 0) ? zero4 : one4;
    maska = (gtx == mx) ? zero4 : maska;

    float4 maskc = (gtz == 0) ? mask_0yzw : one4;
    maskc = (gtz == mz) ? mask_xyz0 : maskc;
  }

  {
    int gci1013 = 3 * (x1 * nyz + y3 * nz) + z1;
    int gci1113 = 3 * (x1 * nyz + y4 * nz) + z1;
    int gci0113 = 3 * (x0 * nyz + y4 * nz) + z1;

    w_hx111[hook(10, tz1)] = hh[hook(5, gci1013 + 0 * nz)];
    w_hy111[hook(11, tz1)] = hh[hook(5, gci1013 + 1 * nz)];
    w_hz111[hook(12, tz1)] = hh[hook(5, gci1013 + 2 * nz)];

    w_hx111[hook(10, tz1 + 65)] = hh[hook(5, gci1113 + 0 * nz)];
    w_hy111[hook(11, tz1 + 65)] = hh[hook(5, gci1113 + 1 * nz)];
    w_hz111[hook(12, tz1 + 65)] = hh[hook(5, gci1113 + 2 * nz)];

    w_hx011[hook(13, tz1)] = hh[hook(5, gci0113 + 0 * nz)];
    w_hy011[hook(14, tz1)] = hh[hook(5, gci0113 + 1 * nz)];
    w_hz011[hook(15, tz1)] = hh[hook(5, gci0113 + 2 * nz)];

    if (tz == 0) {
      w_hx111[hook(10, 0)] = w_hx111[hook(10, 64)].wxyz;
      w_hy111[hook(11, 0)] = w_hy111[hook(11, 64)].wxyz;
      w_hz111[hook(12, 0)] = w_hz111[hook(12, 64)].wxyz;

      w_hx111[hook(10, 0 + 65)] = w_hx111[hook(10, 64 + 65)].wxyz;
      w_hy111[hook(11, 0 + 65)] = w_hy111[hook(11, 64 + 65)].wxyz;
      w_hz111[hook(12, 0 + 65)] = w_hz111[hook(12, 64 + 65)].wxyz;

      w_hx011[hook(13, 0)] = w_hx011[hook(13, 64)].wxyz;
      w_hy011[hook(14, 0)] = w_hy011[hook(14, 64)].wxyz;
      w_hz011[hook(15, 0)] = w_hz011[hook(15, 64)].wxyz;
    }

    barrier(0x01);

    w_ex111[hook(7, tz1 + 195)] += az4 * (w_hy111[hook(11, tz + 65)] - w_hy111[hook(11, tz1 + 65)]) + ay4 * (w_hz111[hook(12, tz1 + 65)] - w_hz111[hook(12, tz1)]);
    w_ey111[hook(8, tz1 + 195)] += ax4 * (w_hz011[hook(15, tz1)] - w_hz111[hook(12, tz1 + 65)]) + az4 * (w_hx111[hook(10, tz1 + 65)] - w_hx111[hook(10, tz + 65)]);
    w_ez111[hook(9, tz1 + 195)] += ay4 * (w_hx111[hook(10, tz1)] - w_hx111[hook(10, tz1 + 65)]) + ax4 * (w_hy111[hook(11, tz1 + 65)] - w_hy011[hook(14, tz1)]);

    float4 maska = (gtx == 0) ? zero4 : one4;
    maska = (gtx == mx) ? zero4 : maska;

    float4 maskb = (gty == my) ? zero4 : one4;

    float4 maskc = (gtz == 0) ? mask_0yzw : one4;
    maskc = (gtz == mz) ? mask_xyz0 : maskc;
  }

  {
    int gci1113 = 3 * (x1 * nyz + y1 * nz) + z1;
    int gci1213 = 3 * (x1 * nyz + y2 * nz) + z1;
    int gci1313 = 3 * (x1 * nyz + y3 * nz) + z1;
    int gci1413 = 3 * (x1 * nyz + y4 * nz) + z1;

    ee[hook(6, gci1113 + 0 * nz)] = w_ex111[hook(7, tz1)];
    ee[hook(6, gci1113 + 1 * nz)] = w_ey111[hook(8, tz1)];
    ee[hook(6, gci1113 + 2 * nz)] = w_ez111[hook(9, tz1)];

    ee[hook(6, gci1213 + 0 * nz)] = w_ex111[hook(7, tz1 + 65)];
    ee[hook(6, gci1213 + 1 * nz)] = w_ey111[hook(8, tz1 + 65)];
    ee[hook(6, gci1213 + 2 * nz)] = w_ez111[hook(9, tz1 + 65)];

    ee[hook(6, gci1313 + 0 * nz)] = w_ex111[hook(7, tz1 + 130)];
    ee[hook(6, gci1313 + 1 * nz)] = w_ey111[hook(8, tz1 + 130)];
    ee[hook(6, gci1313 + 2 * nz)] = w_ez111[hook(9, tz1 + 130)];

    ee[hook(6, gci1413 + 0 * nz)] = w_ex111[hook(7, tz1 + 195)];
    ee[hook(6, gci1413 + 1 * nz)] = w_ey111[hook(8, tz1 + 195)];
    ee[hook(6, gci1413 + 2 * nz)] = w_ez111[hook(9, tz1 + 195)];
  }
}