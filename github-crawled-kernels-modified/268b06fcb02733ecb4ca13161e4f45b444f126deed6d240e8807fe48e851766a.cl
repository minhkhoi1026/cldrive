//{"da":1,"da_offset":2,"dxnorm":4,"dxnorm_offset":5,"ldda":3,"m":0,"sum":7,"x":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void sum_reduce(int n, int i, local double* x);
void sum_reduce(int n, int i, local double* x) {
  barrier(0x01);
  if (n > 1024) {
    if (i < 1024 && i + 1024 < n) {
      x[hook(6, i)] += x[hook(6, i + 1024)];
    }
    barrier(0x01);
  }
  if (n > 512) {
    if (i < 512 && i + 512 < n) {
      x[hook(6, i)] += x[hook(6, i + 512)];
    }
    barrier(0x01);
  }
  if (n > 256) {
    if (i < 256 && i + 256 < n) {
      x[hook(6, i)] += x[hook(6, i + 256)];
    }
    barrier(0x01);
  }
  if (n > 128) {
    if (i < 128 && i + 128 < n) {
      x[hook(6, i)] += x[hook(6, i + 128)];
    }
    barrier(0x01);
  }
  if (n > 64) {
    if (i < 64 && i + 64 < n) {
      x[hook(6, i)] += x[hook(6, i + 64)];
    }
    barrier(0x01);
  }
  if (n > 32) {
    if (i < 32 && i + 32 < n) {
      x[hook(6, i)] += x[hook(6, i + 32)];
    }
    barrier(0x01);
  }
  if (n > 16) {
    if (i < 16 && i + 16 < n) {
      x[hook(6, i)] += x[hook(6, i + 16)];
    }
    barrier(0x01);
  }
  if (n > 8) {
    if (i < 8 && i + 8 < n) {
      x[hook(6, i)] += x[hook(6, i + 8)];
    }
    barrier(0x01);
  }
  if (n > 4) {
    if (i < 4 && i + 4 < n) {
      x[hook(6, i)] += x[hook(6, i + 4)];
    }
    barrier(0x01);
  }
  if (n > 2) {
    if (i < 2 && i + 2 < n) {
      x[hook(6, i)] += x[hook(6, i + 2)];
    }
    barrier(0x01);
  }
  if (n > 1) {
    if (i < 1 && i + 1 < n) {
      x[hook(6, i)] += x[hook(6, i + 1)];
    }
    barrier(0x01);
  }
}

void dsum_reduce(int n, int i, local double* x);
void dsum_reduce(int n, int i, local double* x) {
  barrier(0x01);
  if (n > 1024) {
    if (i < 1024 && i + 1024 < n) {
      x[hook(6, i)] += x[hook(6, i + 1024)];
    }
    barrier(0x01);
  }
  if (n > 512) {
    if (i < 512 && i + 512 < n) {
      x[hook(6, i)] += x[hook(6, i + 512)];
    }
    barrier(0x01);
  }
  if (n > 256) {
    if (i < 256 && i + 256 < n) {
      x[hook(6, i)] += x[hook(6, i + 256)];
    }
    barrier(0x01);
  }
  if (n > 128) {
    if (i < 128 && i + 128 < n) {
      x[hook(6, i)] += x[hook(6, i + 128)];
    }
    barrier(0x01);
  }
  if (n > 64) {
    if (i < 64 && i + 64 < n) {
      x[hook(6, i)] += x[hook(6, i + 64)];
    }
    barrier(0x01);
  }
  if (n > 32) {
    if (i < 32 && i + 32 < n) {
      x[hook(6, i)] += x[hook(6, i + 32)];
    }
    barrier(0x01);
  }
  if (n > 16) {
    if (i < 16 && i + 16 < n) {
      x[hook(6, i)] += x[hook(6, i + 16)];
    }
    barrier(0x01);
  }
  if (n > 8) {
    if (i < 8 && i + 8 < n) {
      x[hook(6, i)] += x[hook(6, i + 8)];
    }
    barrier(0x01);
  }
  if (n > 4) {
    if (i < 4 && i + 4 < n) {
      x[hook(6, i)] += x[hook(6, i + 4)];
    }
    barrier(0x01);
  }
  if (n > 2) {
    if (i < 2 && i + 2 < n) {
      x[hook(6, i)] += x[hook(6, i + 2)];
    }
    barrier(0x01);
  }
  if (n > 1) {
    if (i < 1 && i + 1 < n) {
      x[hook(6, i)] += x[hook(6, i + 1)];
    }
    barrier(0x01);
  }
}

kernel void magmablas_dnrm2_kernel(int m, global double* da, int da_offset, int ldda, global double* dxnorm, int dxnorm_offset) {
  da += da_offset;
  dxnorm += dxnorm_offset;
  const int i = get_local_id(0);

  da += get_group_id(0) * ldda;

  local double sum[256];
  double re, lsum;

  lsum = 0;
  for (int j = i; j < m; j += 256) {
    re = da[hook(1, j)];
    lsum += re * re;
  }
  sum[hook(7, i)] = lsum;

  sum_reduce(256, i, sum);

  if (i == 0)
    dxnorm[hook(4, get_group_id(0))] = sqrt(sum[hook(7, 0)]);
}