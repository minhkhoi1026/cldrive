//{"N":0,"beta":3,"current":1,"sm":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BK_norm_beta(const int N, const int current, local float* sm, global float* beta) {
  size_t tid = get_local_id(0);
  size_t gid = get_global_id(0);
  size_t bls = get_local_size(0);
  size_t gls = get_global_size(0);

  float tidsum = 0.f;
  int i;
  for (i = gid; i < N; i += gls) {
    tidsum += beta[hook(3, current + i)];
  }

  sm[hook(2, tid)] = tidsum;

  barrier(0x01);

  if (bls >= 512) {
    if (tid < 256) {
      sm[hook(2, tid)] += sm[hook(2, tid + 256)];
    }
    barrier(0x01);
  }
  if (bls >= 256) {
    if (tid < 128) {
      sm[hook(2, tid)] += sm[hook(2, tid + 128)];
    }
    barrier(0x01);
  }
  if (bls >= 128) {
    if (tid < 64) {
      sm[hook(2, tid)] += sm[hook(2, tid + 64)];
    }
    barrier(0x01);
  }
  if (bls >= 64) {
    if (tid < 32) {
      sm[hook(2, tid)] += sm[hook(2, tid + 32)];
    }
    barrier(0x01);
  }
  if (bls >= 32) {
    if (tid < 16) {
      sm[hook(2, tid)] += sm[hook(2, tid + 16)];
    }
    barrier(0x01);
  }
  if (bls >= 16) {
    if (tid < 8) {
      sm[hook(2, tid)] += sm[hook(2, tid + 8)];
    }
    barrier(0x01);
  }
  if (bls >= 8) {
    if (tid < 4) {
      sm[hook(2, tid)] += sm[hook(2, tid + 4)];
    }
    barrier(0x01);
  }
  if (bls >= 4) {
    if (tid < 2) {
      sm[hook(2, tid)] += sm[hook(2, tid + 2)];
    }
    barrier(0x01);
  }
  if (bls >= 2) {
    if (tid < 1) {
      sm[hook(2, tid)] += sm[hook(2, tid + 1)];
    }
    barrier(0x01);
  }

  for (i = gid; i < N; i += gls) {
    beta[hook(3, current + i)] /= sm[hook(2, 0)];
  }
}