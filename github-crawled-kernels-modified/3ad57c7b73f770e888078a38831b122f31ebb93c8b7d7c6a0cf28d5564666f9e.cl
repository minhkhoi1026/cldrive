//{"d_Ne":0,"d_mul":2,"d_no":1,"d_psum":6,"d_psum2":7,"d_sums":3,"d_sums2":4,"gridDim":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce_kernel(long d_Ne, long d_no, int d_mul, global float* d_sums, global float* d_sums2, int gridDim) {
  int bx = get_group_id(0);
  int tx = get_local_id(0);
  int ei = (bx * 512) + tx;

  int nf = 512 - (gridDim * 512 - d_no);
  int df = 0;

  local float d_psum[512];
  local float d_psum2[512];

  int i;

  if (ei < d_no) {
    d_psum[hook(6, tx)] = d_sums[hook(3, ei * d_mul)];
    d_psum2[hook(7, tx)] = d_sums2[hook(4, ei * d_mul)];
  }

  if (nf == 512) {
    for (i = 2; i <= 512; i = 2 * i) {
      if ((tx + 1) % i == 0) {
        d_psum[hook(6, tx)] = d_psum[hook(6, tx)] + d_psum[hook(6, tx - i / 2)];
        d_psum2[hook(7, tx)] = d_psum2[hook(7, tx)] + d_psum2[hook(7, tx - i / 2)];
      }

      barrier(0x01);
    }

    if (tx == (512 - 1)) {
      d_sums[hook(3, bx * d_mul * 512)] = d_psum[hook(6, tx)];
      d_sums2[hook(4, bx * d_mul * 512)] = d_psum2[hook(7, tx)];
    }
  }

  else {
    if (bx != (gridDim - 1)) {
      for (i = 2; i <= 512; i = 2 * i) {
        if ((tx + 1) % i == 0) {
          d_psum[hook(6, tx)] = d_psum[hook(6, tx)] + d_psum[hook(6, tx - i / 2)];
          d_psum2[hook(7, tx)] = d_psum2[hook(7, tx)] + d_psum2[hook(7, tx - i / 2)];
        }

        barrier(0x01);
      }

      if (tx == (512 - 1)) {
        d_sums[hook(3, bx * d_mul * 512)] = d_psum[hook(6, tx)];
        d_sums2[hook(4, bx * d_mul * 512)] = d_psum2[hook(7, tx)];
      }
    }

    else {
      for (i = 2; i <= 512; i = 2 * i) {
        if (nf >= i) {
          df = i;
        }
      }

      for (i = 2; i <= df; i = 2 * i) {
        if ((tx + 1) % i == 0 && tx < df) {
          d_psum[hook(6, tx)] = d_psum[hook(6, tx)] + d_psum[hook(6, tx - i / 2)];
          d_psum2[hook(7, tx)] = d_psum2[hook(7, tx)] + d_psum2[hook(7, tx - i / 2)];
        }

        barrier(0x01);
      }

      if (tx == (df - 1)) {
        for (i = (bx * 512) + df; i < (bx * 512) + nf; i++) {
          d_psum[hook(6, tx)] = d_psum[hook(6, tx)] + d_sums[hook(3, i)];
          d_psum2[hook(7, tx)] = d_psum2[hook(7, tx)] + d_sums2[hook(4, i)];
        }

        d_sums[hook(3, bx * d_mul * 512)] = d_psum[hook(6, tx)];
        d_sums2[hook(4, bx * d_mul * 512)] = d_psum2[hook(7, tx)];
      }
    }
  }
}