//{"N":2,"alpha_beta":0,"ll_d":1,"sm":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_sum_alphabeta(global const float* alpha_beta, global float* ll_d, const int N, local float* sm) {
  size_t gid = get_global_id(0);
  size_t lid = get_local_id(0);
  size_t gls = get_global_size(0);
  size_t bls = get_local_size(0);

  float tidsum = 0.f;
  for (int i = gid; i < N; i += gls) {
    tidsum += alpha_beta[hook(0, i)];
  }

  sm[hook(3, gid)] = tidsum;

  barrier(0x01);

  if (bls >= 512) {
    if (lid < 256) {
      sm[hook(3, lid)] += sm[hook(3, lid + 256)];
    }
    barrier(0x01);
  }
  if (bls >= 256) {
    if (lid < 128) {
      sm[hook(3, lid)] += sm[hook(3, lid + 128)];
    }
    barrier(0x01);
  }
  if (bls >= 128) {
    if (lid < 64) {
      sm[hook(3, lid)] += sm[hook(3, lid + 64)];
    }
    barrier(0x01);
  }
  if (bls >= 64) {
    if (lid < 32) {
      sm[hook(3, lid)] += sm[hook(3, lid + 32)];
    }
    barrier(0x01);
  }

  if (lid < 16) {
    if (bls >= 32) {
      sm[hook(3, lid)] += sm[hook(3, lid + 16)];
    }
    if (bls >= 16) {
      sm[hook(3, lid)] += sm[hook(3, lid + 8)];
    }
    if (bls >= 8) {
      sm[hook(3, lid)] += sm[hook(3, lid + 4)];
    }
    if (bls >= 4) {
      sm[hook(3, lid)] += sm[hook(3, lid + 2)];
    }
    if (bls >= 2) {
      sm[hook(3, lid)] += sm[hook(3, lid + 1)];
    }
  }

  if (lid == 0) {
    ll_d[hook(1, 0)] = sm[hook(3, 0)];
  }
}