//{"b":4,"ee":6,"hh":5,"nx":1,"ny":2,"nz":3,"src":0,"w_ex000":10,"w_ex100":13,"w_ey000":11,"w_ey100":14,"w_ez000":12,"w_ez100":15,"w_hx000":7,"w_hy000":8,"w_hz000":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hcomp_kern(float4 src, int nx, int ny, int nz, float4 b, global float4* hh, global float4* ee) {
  float4 zero4 = (float4){0.0f, 0.0f, 0.0f, 0.0f};
  float4 one4 = (float4){1.0f, 1.0f, 1.0f, 1.0f};
  float4 mask_xyz0 = (float4){1.0f, 1.0f, 1.0f, 0.0f};
  float4 bx4 = (float4){b.x, b.x, b.x, b.x};
  float4 by4 = (float4){b.y, b.y, b.y, b.y};
  float4 bz4 = (float4){b.z, b.z, b.z, b.z};

  local float4 w_hx000[65];
  local float4 w_hy000[65];
  local float4 w_hz000[65];

  local float4 w_ex000[130];
  local float4 w_ey000[130];
  local float4 w_ez000[130];

  local float4 w_ex100[65];
  local float4 w_ey100[65];
  local float4 w_ez100[65];

  int nyz = ny * nz;

  int mx = nx - 1;
  int my = ny - 1;
  int mz = nz - 1;

  int nx2 = nx / 2;
  int ny2 = ny / 2;

  int gtx = get_global_id(0);
  int gty = get_global_id(1);
  int gtz = get_global_id(2);

  int gtx1 = (gtx + 1) % nx;

  int y = 4 * gty;
  int y1 = y + 1;

  int tz = get_local_id(2);

  int gci0003 = 3 * (gtx * nyz + y * nz) + gtz;

  w_hx000[hook(7, tz)] = hh[hook(5, gci0003 + 0 * nz)];
  w_hy000[hook(8, tz)] = hh[hook(5, gci0003 + 1 * nz)];
  w_hz000[hook(9, tz)] = hh[hook(5, gci0003 + 2 * nz)];

  {
    int gci0003 = 3 * (gtx * nyz + y * nz) + gtz;
    int gci0103 = 3 * (gtx * nyz + y1 * nz) + gtz;
    int gci1003 = 3 * (gtx1 * nyz + y * nz) + gtz;

    w_ex000[hook(10, tz)] = ee[hook(6, gci0003 + 0 * nz)];
    w_ey000[hook(11, tz)] = ee[hook(6, gci0003 + 1 * nz)];
    w_ez000[hook(12, tz)] = ee[hook(6, gci0003 + 2 * nz)];

    w_ex000[hook(10, tz + 65)] = ee[hook(6, gci0103 + 0 * nz)];
    w_ey000[hook(11, tz + 65)] = ee[hook(6, gci0103 + 1 * nz)];
    w_ez000[hook(12, tz + 65)] = ee[hook(6, gci0103 + 2 * nz)];

    w_ex100[hook(13, tz)] = ee[hook(6, gci1003 + 0 * nz)];
    w_ey100[hook(14, tz)] = ee[hook(6, gci1003 + 1 * nz)];
    w_ez100[hook(15, tz)] = ee[hook(6, gci1003 + 2 * nz)];

    if (tz == 0) {
      w_ex000[hook(10, 64)] = w_ex000[hook(10, 0)].yzwx;
      w_ex000[hook(10, 64 + 65)] = w_ex000[hook(10, 0 + 65)].yzwx;

      w_ey000[hook(11, 64)] = w_ey000[hook(11, 0)].yzwx;
      w_ey000[hook(11, 64 + 65)] = w_ey000[hook(11, 0 + 65)].yzwx;

      w_ez000[hook(12, 64)] = w_ez000[hook(12, 0)].yzwx;
      w_ez000[hook(12, 64 + 65)] = w_ez000[hook(12, 0 + 65)].yzwx;
    }

    barrier(0x01);

    w_hx000[hook(7, tz)] += bz4 * (w_ey000[hook(11, tz + 1)] - w_ey000[hook(11, tz)]) + by4 * (w_ez000[hook(12, tz)] - w_ez000[hook(12, tz + 65)]);
    w_hy000[hook(8, tz)] += bx4 * (w_ez100[hook(15, tz)] - w_ez000[hook(12, tz)]) + bz4 * (w_ex000[hook(10, tz)] - w_ex000[hook(10, tz + 1)]);
    w_hz000[hook(9, tz)] += by4 * (w_ex000[hook(10, tz + 65)] - w_ex000[hook(10, tz)]) + bx4 * (w_ey000[hook(11, tz)] - w_ey100[hook(14, tz)]);
  }

  {
    int gci0003 = 3 * (gtx * nyz + y * nz) + gtz;

    hh[hook(5, gci0003 + 0 * nz)] = w_hx000[hook(7, tz)];
    hh[hook(5, gci0003 + 1 * nz)] = w_hy000[hook(8, tz)];
    hh[hook(5, gci0003 + 2 * nz)] = w_hz000[hook(9, tz)];
  }
}