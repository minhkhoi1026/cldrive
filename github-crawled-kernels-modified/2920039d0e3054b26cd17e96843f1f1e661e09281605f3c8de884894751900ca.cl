//{"N":6,"alpha_d":0,"alphabeta_d":2,"beta_d":1,"current":5,"gamma_d":3,"sm":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_norm_alphabeta(global const float* alpha_d, global const float* beta_d, global float* alphabeta_d, global float* gamma_d, local float* sm, const int current, const int N) {
  size_t gid = get_global_id(0);
  size_t lid = get_local_id(0);
  size_t gls = get_global_size(0);
  size_t bls = get_local_size(0);

  float tidsum = 0.f;
  float tmp;
  for (int i = gid; i < N; i += gls) {
    alphabeta_d[hook(2, i)] = tmp = alpha_d[hook(0, current + i)] * beta_d[hook(1, current + i)];
    tidsum += tmp;
  }

  sm[hook(4, gid)] = tidsum;

  barrier(0x01);

  if (bls >= 512) {
    if (lid < 256) {
      sm[hook(4, lid)] += sm[hook(4, lid + 256)];
    }
    barrier(0x01);
  }
  if (bls >= 256) {
    if (lid < 128) {
      sm[hook(4, lid)] += sm[hook(4, lid + 128)];
    }
    barrier(0x01);
  }
  if (bls >= 128) {
    if (lid < 64) {
      sm[hook(4, lid)] += sm[hook(4, lid + 64)];
    }
    barrier(0x01);
  }
  if (bls >= 64) {
    if (lid < 32) {
      sm[hook(4, lid)] += sm[hook(4, lid + 32)];
    }
    barrier(0x01);
  }

  if (lid < 16) {
    if (bls >= 32) {
      sm[hook(4, lid)] += sm[hook(4, lid + 16)];
    }
    if (bls >= 16) {
      sm[hook(4, lid)] += sm[hook(4, lid + 8)];
    }
    if (bls >= 8) {
      sm[hook(4, lid)] += sm[hook(4, lid + 4)];
    }
    if (bls >= 4) {
      sm[hook(4, lid)] += sm[hook(4, lid + 2)];
    }
    if (bls >= 2) {
      sm[hook(4, lid)] += sm[hook(4, lid + 1)];
    }
  }

  barrier(0x01);

  for (int i = gid; i < N; i += gls) {
    gamma_d[hook(3, current + i)] = alphabeta_d[hook(2, i)] / sm[hook(4, 0)];
  }
}