//{"blk_rows":2,"expect_sigma":0,"expect_sigma_sym":1,"start":4,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_update_expectsigma(global float* expect_sigma, global const float* expect_sigma_sym, const int blk_rows, const int width, const unsigned int start) {
  volatile local int2 blkid;
  int lid_x = get_local_id(0);
  int lid_y = get_local_id(1);

  int bn = get_group_id(1);

  if (lid_x == 0 && lid_y == 0) {
    int i;
    int upper, lower;

    for (i = 2, lower = 0, upper = 1; i <= (blk_rows + 1); i++) {
      if (bn >= lower && bn < upper) {
        blkid.y = i - 2;
        blkid.x = bn - lower;
        break;
      } else {
        lower = upper;
        upper = upper + i;
      }
    }
  }

  barrier(0x01);

  size_t gx, gy, gid;
  gx = blkid.x * 16 + lid_x;
  gy = blkid.y * 16 + lid_y;
  gid = gy * width + gx;

  size_t gid_sym = gx * width + gy;

  float a = expect_sigma_sym[hook(1, gid)];
  float b = expect_sigma_sym[hook(1, gid_sym)];

  if (gx == gy) {
    a = a + 0.01f;
    b = b + 0.01f;
  }

  if (a > b) {
    expect_sigma[hook(0, start + gid)] = a;
    expect_sigma[hook(0, start + gid_sym)] = a;
  } else {
    expect_sigma[hook(0, start + gid)] = b;
    expect_sigma[hook(0, start + gid_sym)] = b;
  }
}